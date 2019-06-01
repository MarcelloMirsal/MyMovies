//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 07/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit
import Alamofire

let searchCellId = "searchCellId"

// TODO:- The search scope is limited to show only 20 results(Only the results from first page)


class SearchViewController: UITableViewController ,UISearchResultsUpdating {
    
    // MARK:- Properties
    var filteredMovies = [Movie]()
    var lastSearchRequest: DataRequest!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK:- UI Properties
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK:- Methods
    func setupNavigationBar() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func setupAppearance() {
        view.backgroundColor = .white
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: searchCellId)
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupNavigationBar()
        setupTableView()
        setupSearchController()
    }
    
    // MARK:- handlers
    func handle(searchQuery: String) {
        if let _ = lastSearchRequest {
            lastSearchRequest.cancel()
            lastSearchRequest = nil
        }
        
        let urlRequest = URLBuilder.url(for: .search, value: searchQuery)
        let urlQuery = URL(string: urlRequest)!
        self.lastSearchRequest = Alamofire.request(urlQuery).responseData { (dataResponse) in
            guard let data = dataResponse.data else {fatalError()}
            let apiResponse = try? JSONDecoder().decode(ApiResponse<Movie>.self, from: data)
            if let movies = apiResponse?.results {
                self.filteredMovies = movies
                self.tableView.reloadData()
            }
        }
    }
}


// MARK:- UITableViewDataSource and Delegate Implementation
extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredMovies.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellId, for: indexPath)
        let movie = filteredMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = filteredMovies[indexPath.row]
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movie = movie
        present(movieDetailsViewController
            , animated: true, completion: nil)
    }
}

// MARK:- UISearchResultsUpdating Implementation
extension SearchViewController {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: Bug when searching for movie if name > 3 letters
        if searchBarIsEmpty() {
            filteredMovies.removeAll()
            tableView.reloadData()
        }
        handle(searchQuery: searchController.searchBar.text!)
    }
}
