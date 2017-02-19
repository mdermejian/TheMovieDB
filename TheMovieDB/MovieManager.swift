//
//  MovieManager.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 15/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation
import Alamofire

/*
This is the network controller for Movie related API calls: it talks to the backend and then pushes data into your cache, into your persistence engine. (not implemented yet here)
*/
class MovieManager {
	
	//MARK: methods
	
	func getMovies(page: Int = 1, startYear: Int, endYear: Int, completion: @escaping (_ success: Bool, _ totalCount: Int?, _ hasMore: Bool?, _ movies: [Movie]?) -> Void) {
		
		let request = MovieRouter(endpoint: .GetMovies(page: page, startYear: startYear, endYear: endYear))
		Alamofire.request(request)
			
			//Validates that the response has a status code in the default acceptable range of 200…299, and that the content type matches any specified in the Accept HTTP header field.
			//If validation fails, subsequent calls to response handlers will have an associated error.
			.validate()
			
			//Use Generic Response Object Serialization to map the response into a GetAllMoviesResponse object
			.responseObject(completionHandler: { (response: DataResponse<GetMoviesResponse>) in
				completion(response.result.isSuccess,
				           response.result.value?.totalResults,
				           response.result.value?.hasMore,
				           response.result.value?.movies)
			})
		
	}
}
