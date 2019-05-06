//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 07/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

class SearchViewController: ListsViewController {
    
    // MARK:- Properties
    
    // MARK:- Methods
    override func setupNavigationBar() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        setupAppearance()
        setupNavigationBar()
        setupTableView()
    }
    
}

