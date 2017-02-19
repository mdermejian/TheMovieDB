//
//  MovieRouter.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 15/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Alamofire

//Encapsulates the details of a URLRequest for each MovieEndpoint API case
class MovieRouter: URLRequestConvertible, APIConfigurator {
	
	var endpoint: MovieEndpoint
	init(endpoint: MovieEndpoint) {
		self.endpoint = endpoint
	}
	
	
	//MARK: - APIConfigurator implementation - URL Request properties
	var baseURL: URL {
		return URL(string: Config.baseURLPath)!
	}
	
	var method: HTTPMethod {
		switch self.endpoint {
		case .GetMovies: return .get
		}
	}
	
	var encoding: Alamofire.ParameterEncoding {
		switch self.endpoint {
		case .GetMovies: return URLEncoding.default //return nil
		}
	}
	
	//relative path to be appended to the base url
	var relativePath: String {
		switch self.endpoint {
		case .GetMovies:
			return ("/discover/movie")
		}
	}
	
	var parameters: [String: AnyObject]? {
		var params: [String:AnyObject] = [:]
		
		switch self.endpoint {
		case .GetMovies(let page, let startYear, let endYear):
			
			//example call:
			//https://api.themoviedb.org/3/discover/movie?
			//api_key=0c6d54a73d7fe6aa61cea779b51e1067
			//&language=en-US
			//&sort_by=release_date.desc
			//&include_adult=false
			//&page=1
			//&release_date.gte=2010
			//&release_date.lte=2017
			
			
			params["api_key"] = "\(Config.apiKey)" as AnyObject
			
			params["language"] = "en-US" as AnyObject
			
			//ask the backend for the list of movies sorted by release date in descending order
			params["sort_by"] = "release_date.desc" as AnyObject
			
			//no adult results for now...
			params["include_adult"] = "false" as AnyObject
			
			//When the response exceeds the per-page maximum, you can paginate through the records by incrementing the "page" parameter
			params["page"] = "\(page)" as AnyObject
			
			//Set the start year
			params["primary_release_date.gte"] = "\(startYear)" as AnyObject
			
			//...and the end year
			params["primary_release_date.lte"] = "\(endYear)" as AnyObject
		}
		
		return params
	}
	
	var timeoutInterval: TimeInterval {
		return Config.timeout
	}
	
	var defaultHeaders: [String: String] {
		
		var headers: [String:String] = [:]
		
		/*
		The API is a JSON API.
		Must set an Accept: application/json header on all requests.
		*/
		headers["Accept"] = "application/json"
		
		return headers
	}
	
	
	
	// MARK: - URLRequestConvertible
	func asURLRequest() throws -> URLRequest {
		
		//build the URLRequest from all the individual components
		var urlRequest = try URLRequest(url: baseURL.appendingPathComponent(relativePath),
		                                method: method,
		                                headers: defaultHeaders)
		urlRequest.timeoutInterval = timeoutInterval
		urlRequest.cachePolicy = .useProtocolCachePolicy
		
		switch self.endpoint {
		case .GetMovies:
			return try encoding.encode(urlRequest, with: parameters)
		}
	}
}
