//
//  Constants.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 15/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import UIKit

struct Config {
	
	static let baseURLPath = "https://api.themoviedb.org/3"
	static let imagesURL = "https://image.tmdb.org/t/p/w300"

	//API call timeout interval
	static let timeout = TimeInterval(15)
	
	static let apiKey = "0c6d54a73d7fe6aa61cea779b51e1067"
	
	static let minimumFilterYear = 1970
	static let maximumFilterYear = 2017
}

// This would hold the palette of special colors being used within the app
struct Colors {
	
	static let theMovieDBGreen	= UIColor(red: 0/255, green: 212/255, blue: 117/255, alpha: 1.0)
	
}
