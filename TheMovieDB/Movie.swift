//
//  Movie.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 15/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation
import UIKit
import Commons

struct Movie: CustomStringConvertible {
	
	// MARK: - stored properties
	
	var posterPath: String?
	var overview: String?
	var releaseYear: Int?
	var id: Int?
	var originalTitle: String?
	
	// MARK: - computed properties
	
	var posterURL: URL? {
		//Returns nil if a URL cannot be formed with the string (for example, if the string contains characters that are illegal in a URL, or is an empty string)
		//or if the logo string is empty
		if posterPath != nil {
			let urlString = "\(Config.imagesURL)\(posterPath!)"
			return URL(string: urlString)
		}
		return nil
	}
	
	var defaultMovieImage: UIImage {
		return UIImage(named: "poster-placeholder")!
	}

	
	// MARK: - ResponseObjectSerializable protocol implementation
	
	fileprivate typealias Fields = MovieKey
	fileprivate typealias Value = AnyObject
	
	init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: AnyObject] else { return nil }
		
		if let posterPath = representation[Fields.PosterPath.rawValue] as? String { self.posterPath = posterPath }
		if let overview = representation[Fields.Overview.rawValue] as? String { self.overview = overview }
		if let releaseDate = representation[Fields.ReleaseDate.rawValue] as? String {
			let date = NSDate(from: releaseDate)
			self.releaseYear = date?.year()
		}
		if let id = representation[Fields.ID.rawValue] as? NSNumber { self.id = id.intValue }
		if let originalTitle = representation[Fields.OriginalTitle.rawValue] as? String { self.originalTitle = originalTitle }
		
	}
}

// MARK: - Comparable protocol implementation

extension Movie: Comparable {}

func == (lhs: Movie, rhs: Movie) -> Bool {
	return lhs.id != nil
		&& rhs.id != nil
		&& lhs.id == rhs.id
}

func < (lhs: Movie, rhs: Movie) -> Bool {
	
	guard lhs.releaseYear != nil && rhs.releaseYear != nil else {
		return false
	}
	
	if lhs.releaseYear! < rhs.releaseYear! {
		return true
	}

	return false
}

// MARK: - API Keys

// The keys to the values received in the API response
// These do not represent the entirety of the response
// we are only choosing a select few to parse and store
public enum MovieKey: String {
	
	case ID				= "id"
	case PosterPath		= "poster_path"
	case Overview		= "overview"
	case ReleaseDate	= "release_date"
	case OriginalTitle	= "original_title"
}
