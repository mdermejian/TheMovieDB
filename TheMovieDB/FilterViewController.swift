//
//  FilterViewController.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 16/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import UIKit
import TTRangeSlider

class FilterViewController: UIViewController {

	// MARK: - Stored Properties

	var startYear = Config.minimumFilterYear
	var endYear = Config.maximumFilterYear
	
	// MARK: - IBOutlets

	@IBOutlet weak var slider: TTRangeSlider! {
		didSet {
			slider.minValue = Float(Config.minimumFilterYear)
			slider.maxValue = Float(Config.maximumFilterYear)
			
			slider.selectedMaximum = Float(endYear)
			slider.selectedMinimum = Float(startYear)
			
			slider.minDistance = 0
			
			slider.enableStep = true
			slider.step = 1.0
			
			slider.handleDiameter = 25
			slider.selectedHandleDiameterMultiplier = 1.3
			
			slider.tintColorBetweenHandles = UIColor.red
			slider.lineHeight = 8

			let formatter = NumberFormatter()
			formatter.numberStyle = .none
			slider.numberFormatterOverride = formatter
			
			slider.delegate = self
		}
	}
	
	// MARK: - IBActions
	
	@IBAction func cancelTapped(_ sender: UIBarButtonItem) {
		dismiss()
	}
	
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
		performSegue(withIdentifier: "unwindToMoviesTableView", sender: self)
	}

	private func dismiss () {
		presentingViewController?.dismiss(animated: true)
	}

}

extension FilterViewController: TTRangeSliderDelegate {
	func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
		
		startYear = Int(selectedMinimum)
		endYear = Int(selectedMaximum)
		
	}
}
