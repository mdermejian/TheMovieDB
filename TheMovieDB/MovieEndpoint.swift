//
//  MovieEndpoint.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 15/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation

/*
	enum listing the Movie end points
*/
enum MovieEndpoint {
	
	case GetMovies(page: Int, startYear: Int, endYear: Int)
	
}
