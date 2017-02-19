//
//  MovieCell.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 15/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {
	
	//MARK: API
	var movie: Movie? {
		didSet {
			updateUI()
		}
	}
	
	// MARK: IBOutlets
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var overviewLabel: UILabel!
	@IBOutlet weak var posterImageView: UIImageView!
	
	//MARK: UI update
	private func updateUI () {
		
		guard let movie = movie else { return }
		
		let placeholderImage = movie.defaultMovieImage
		if let url = movie.posterURL {
			posterImageView.af_setImage(withURL: url,
			                          placeholderImage: placeholderImage,
			                          filter: nil,
			                          progress: nil,
			                          progressQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
			                          imageTransition: .crossDissolve(0.1),
			                          runImageTransitionIfCached: false,
			                          completion: nil)
		}else {
			posterImageView.image = placeholderImage
		}

		titleLabel.text = movie.originalTitle
		overviewLabel.text = movie.overview
		
	}
}
