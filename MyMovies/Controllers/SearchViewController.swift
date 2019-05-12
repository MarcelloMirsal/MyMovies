//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 07/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

class SearchViewController: ListsViewController, UISearchResultsUpdating {
    
    // MARK:- Properties
    var filteredMovies = [Movie]()
    var apiResponse: ApiResponse<Movie>!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK:- Methods
    override func setupNavigationBar() {
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
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMovies = apiResponse.results.filter({( movie : Movie) -> Bool in
            return movie.title.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let movie = filteredMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        setupAppearance()
        setupNavigationBar()
        setupTableView()
        setupSearchController()
    }
    
    // MARK:- handlers
    func handle(searchQuery: String) {
        NetworkManager().response(for: .search, value: searchQuery) { (dataResponse) in
            guard let data = dataResponse.data else {return}
            let apiResponse = try? JSONDecoder().decode(ApiResponse<Movie>.self, from: data)
            if let movies = apiResponse?.results {
                print(searchQuery)
                self.filteredMovies = movies
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK:- UISearchResultsUpdating protocol

extension SearchViewController {
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty() {
            filteredMovies.removeAll()
            tableView.reloadData()
        }
        handle(searchQuery: searchController.searchBar.text!)
    }
}
