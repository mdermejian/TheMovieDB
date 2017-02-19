//
//  MovieTests.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 19/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import XCTest
@testable import TheMovieDB

class MovieTests: XCTestCase {
	
	var blankMovie: [String: AnyObject] = [:]
	let dummyResponse = HTTPURLResponse()
	
	override func tearDown() {
		super.tearDown()
		blankMovie = [:]
	}
	
	func testConstructorReturnsNonNil() {
		
		let movie = Movie(response: dummyResponse, representation: blankMovie)
		XCTAssertNotNil(movie, "movie should not be nil")
		
	}
	
	func testPropertiesAreNil() {
		
		guard let movie = Movie(response: dummyResponse, representation: blankMovie) else {
			XCTFail("guard statement failed")
			return
		}

		XCTAssertNil(movie.posterPath, "uninitialized optional property should be nil")
		XCTAssertNil(movie.overview, "uninitialized optional property should be nil")
		XCTAssertNil(movie.releaseYear, "uninitialized optional property should be nil")
		XCTAssertNil(movie.id, "uninitialized optional property should be nil")
		XCTAssertNil(movie.originalTitle, "uninitialized optional property should be nil")
		XCTAssertNil(movie.posterURL, "posterURL computed property should be nil when posterPath is nil")
	}
	
	func testInvalidRepresentation() {
		
		let invalidRepresentation: [Int: String] = [1:"xxx"]
		let movie = Movie(response: dummyResponse, representation: invalidRepresentation)
		XCTAssertNil(movie, "movie should be nil")
	}
	
	func testValidRepresentation() {
		
		let validMovieRepresentation =
			[
				"id": 76515,
				"overview":"An examination of the Oscar-winning director who brought to life some of cinema's most beloved motion pictures.",
				"release_date":"2017-01-01",
				"poster_path":"/AhPhGXxSn6BAYVZEhPnhekIBvD7.jpg",
				"original_title":"John G. Avildsen: King of the Underdogs"
			] as [String : Any]
		
		let movie = Movie(response: dummyResponse, representation: validMovieRepresentation)
		XCTAssertNotNil(movie, "movie should not be nil")
		
		XCTAssertTrue(movie!.id == 76515)
		XCTAssertTrue(movie!.posterPath == "/AhPhGXxSn6BAYVZEhPnhekIBvD7.jpg")
		XCTAssertTrue(movie!.overview == "An examination of the Oscar-winning director who brought to life some of cinema's most beloved motion pictures.")
		XCTAssertTrue(movie!.releaseYear == 2017)
		XCTAssertTrue(movie!.originalTitle == "John G. Avildsen: King of the Underdogs")
		
		let urlString = "\(Config.imagesURL)\(movie!.posterPath!)"
		XCTAssertTrue(movie!.posterURL == URL(string: urlString))
		
	}
	
	func testEquatable() {
		var movie1 = Movie(response: dummyResponse, representation: blankMovie)
		var movie2 = Movie(response: dummyResponse, representation: blankMovie)
		
		movie1?.id = 1
		movie2?.id = 1
		XCTAssertTrue(movie1 == movie2, "movies should be equal")
		
		movie1?.id = 1
		movie2?.id = 2
		XCTAssertFalse(movie1 == movie2, "movies should NOT be equal")
		
		movie1?.id = nil
		movie2?.id = 2
		XCTAssertFalse(movie1 == movie2, "movies should NOT be equal")
		
		movie1?.id = 1
		movie2?.id = nil
		XCTAssertFalse(movie1 == movie2, "movies should NOT be equal")
		
		movie1?.id = nil
		movie2?.id = nil
		XCTAssertFalse(movie1 == movie2, "movies should NOT be equal")
		
	}
	
	func testComparable() {
		var movie1 = Movie(response: dummyResponse, representation: blankMovie)
		var movie2 = Movie(response: dummyResponse, representation: blankMovie)
		
		XCTAssertFalse(movie1! < movie2!, "If one or both releaseYear properties are nil, movie1 < movie2 should return false!")
		
		movie1?.releaseYear = 2001
		movie2?.releaseYear = 2001
		XCTAssertFalse(movie1! < movie2!, "For the same releaseYear movie1 < movie2 should return false!")
		
		movie1?.releaseYear = 2001
		movie2?.releaseYear = 2002
		XCTAssertTrue(movie1! < movie2!, "A movie that was released before another should be <")
		
		movie1?.releaseYear = 2001
		movie2?.releaseYear = 2000
		XCTAssertFalse(movie1! < movie2!, "A movie that was released after another should NOT be <")
		
	}

}
