//
//  GetMoviesResponse.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 15/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation

/*
	The keys in the key-value pairs received from the backend response to GetAllMovies
*/
fileprivate enum GetMoviesResponseFields: String {
	
	case Results		= "results"
	case Page			= "page"
	case TotalPages		= "total_pages"
	case TotalResults	= "total_results"
}

/*
	The backend response to GetMoviesResponse API call
*/
struct GetMoviesResponse: ResponseObjectSerializable {
	
	//MARK: - stored properties
	var movies: [Movie]?
	var totalResults: Int?
	var page: Int?
	var totalPages: Int?
	
	//MARK: - computed properties
	//indicates whether there are more records to be fetched
	var hasMore: Bool {
		return page != totalPages
	}
	
	var nextPage: Int? {
		guard let page = page else { return nil }
		return hasMore ? page+1 : nil
	}
	
	// MARK: ResponseObjectSerializable
	
	fileprivate typealias Fields = GetMoviesResponseFields
	
	init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: AnyObject]
			else { return nil }
		
		var _movies: [Movie] = []
		if let allMoviesRepresentation = representation[Fields.Results.rawValue] as? [[String:AnyObject]] {
			for movieRepresentation in allMoviesRepresentation {
				if let movie = Movie(response: response, representation: movieRepresentation as AnyObject) {
					_movies.append(movie)
				}
			}
		}
		movies = _movies
		
		if let currentPage = representation[Fields.Page.rawValue] as? Int { self.page = currentPage }
		if let totalResults = representation[Fields.TotalResults.rawValue] as? Int { self.totalResults = totalResults }
		if let totalPages = representation[Fields.TotalPages.rawValue] as? Int { self.totalPages = totalPages }
		
	}
}

