//
//  CustomStringConvertible.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 15/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import Foundation

// CustomStringConvertible default implementation
// makes it easy for classes to adopt CustomStringConvertible without having to provide an implementation of "description"
extension CustomStringConvertible {
	
	var description : String {
		var description = "!***** \(type(of: self)) *****!\n"
		let selfMirror = Mirror(reflecting: self)
		for child in selfMirror.children {
			if let propertyName = child.label {
				description += "\(propertyName) : \(child.value) \n"
			}
		}
		return description
	}
}
