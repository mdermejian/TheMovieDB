//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 17/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
	
	// MARK: stored properties

	//implicitly unwrapped optional. Will prompt development with error if not set
	var movie: Movie!

	// MARK: - IBOutlets

	@IBOutlet weak var posterImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var releaseLabel: UILabel!
	@IBOutlet weak var overviewLabel: UILabel!
	
	// MARK: - View controller lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
	}

	// MARK: UI Updates
	private func updateUI() {
		
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
		releaseLabel.text = "(\(movie.releaseYear!))"
		navigationItem.title = "\(movie.id!)"
	}
	
}
