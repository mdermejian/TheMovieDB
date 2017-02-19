//
//  MoviesTableViewController.swift
//  TheMovieDB
//
//  Created by Marc Dermejian on 15/02/2017.
//  Copyright © 2017 Marc Dermejian. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {

	// MARK: Stored properties
	
	// Current page - this is incremented in the API callback closure
	private var page = 1

	// Start year - this is used to limit the results in the API call
	private var startYear = 2010

	// End year - this is used to limit the results in the API call
	private var endYear = 2017

	private var isLoading = false {
		didSet {
			loadingFooterView?.isHidden = !isLoading
			UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
		}
	}
	
	// This is set from the backend when the nextPage is not null
	private var hasMore = true {
		didSet {
			if !hasMore { tableView.tableFooterView = nil }
		}
	}
	
	// Total number of records available. This is set from the backend
	private var totalRecords = 0 {
		didSet {
			if let _ = navigationItem.title { navigationItem.title = "\(Constants.Movie_Title) (\(String(totalRecords)))" }
		}
	}

	//List of movies for the table view
	private var movies: [Movie] = []

	private let movieManager = MovieManager()
	
	// MARK: Constants
	
	//Keep constants' scope as small as possible
	private struct Constants {
		static let CellReuseId = "MovieCell"
		
		static let MovieDetailSegueIdentifier = "showDetail"
		
		static let Movie_Title = NSLocalizedString("Movie_Title", comment: "The title of the Movies table view")
		static let Network_Error_Message_Title = NSLocalizedString("Network_Error_Message_Title", comment: "The title of the network error message")
		static let Network_Error_Message_Body = NSLocalizedString("Network_Error_Message_Body", comment: "The body of the network error message")
		static let OK_Action = NSLocalizedString("OK_Action", comment: "Okay button title")
	}

	// MARK: IBOutlets
	
	@IBOutlet weak var loadingFooterView: UIView!

	// MARK: - View controller lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = Constants.Movie_Title
		clearsSelectionOnViewWillAppear = true
		
		loadNextBatch()
	}
	
	private func resetInternalState() {
		movies.removeAll()
		page = 1
	}

	// MARK: Networking
	
	private func loadNextBatch() {
		
		guard isLoading == false else { return }
		
		isLoading = true
		
		movieManager.getMovies(page: page, startYear: startYear, endYear: endYear) { (success, totalCount, hasMore, _movies) in
			
			self.isLoading = false
			
			guard success == true, let _movies = _movies, let hasMore = hasMore, let totalCount = totalCount else {
				
				//present alert controller with error message
				let alertController = UIAlertController(title: Constants.Network_Error_Message_Title, message: Constants.Network_Error_Message_Body, preferredStyle: .alert)
				let okAction = UIAlertAction(title: Constants.OK_Action, style: .default)
				alertController.addAction(okAction)
				self.present(alertController, animated: true)
				
				return
			}
			
			self.page += 1
			self.totalRecords = totalCount
			self.hasMore = hasMore
			
			var indexPaths: [IndexPath] = []
			for movie in _movies {
				let row = self.movies.count
				indexPaths += [IndexPath(row: row, section:0)]
				self.movies += [movie]
			}
			
			OperationQueue.main.addOperation {
				self.tableView.beginUpdates()
				self.tableView.insertRows(at: indexPaths, with: .fade)
				self.tableView.endUpdates()
			}
		}
	}

	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movies.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseId, for: indexPath) as! MovieCell
		cell.movie = movies[indexPath.row]
		return cell
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		//when the cell before last is about to appear, trigger the next batch load
		if indexPath == IndexPath(row: movies.count-2, section: 0) && hasMore {
			loadNextBatch()
		}
	}
	
	// MARK: - Table view Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: Constants.MovieDetailSegueIdentifier, sender: movies[indexPath.row])
	}
	
	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let destinationViewController = segue.destination as? FilterViewController {
			destinationViewController.startYear = startYear
			destinationViewController.endYear = endYear
		}
		
		if let destinationViewController = segue.destination as? MovieDetailViewController,
			let movie = sender as? Movie
			{
			destinationViewController.movie = movie
		}
	}

	@IBAction func unwindToMoviesView(sender: UIStoryboardSegue) {
		
		// Filter edited
		if let sourceViewController = sender.source as? FilterViewController {
			
			if startYear != sourceViewController.startYear || endYear != sourceViewController.endYear {
				startYear = sourceViewController.startYear
				endYear = sourceViewController.endYear
				
				resetInternalState()
				tableView.reloadData()
				
				loadNextBatch()
			}
		}
	}
}
