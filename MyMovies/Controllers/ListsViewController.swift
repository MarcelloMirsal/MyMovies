//
//  ListsViewController.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 06/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

let cellID = "cellId"

class ListsViewController: UITableViewController {
    
    // MARK:- Properties
    var apiResponse: ApiResponse<Movie>!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var listType: List = .favorites
    
    enum List: String {
        case favorites = "Favorites"
        case watchList = "Watch List"
    }
    
    
    // MARK:- Methods
    func setupAppearance() {
        view.backgroundColor = .white
    }
    
    func setupNavigationBar() {
        navigationItem.title = listType.rawValue
        navigationController?.navigationBar.prefersLargeTitles = true
        let listBarButtonItem = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(handleListChange))
        navigationItem.rightBarButtonItem = listBarButtonItem
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.rowHeight = 136
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    func setListContents(for type: List) {
        if listType == type {return}
        switch type {
        case .favorites:
            listType = type
            navigationItem.title = listType.rawValue
            loadContents()
        case .watchList:
            listType = type
            navigationItem.title = listType.rawValue
            loadContents()
        }
    }
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupNavigationBar()
        setupTableView()
        loadContents()
    }
    
    // MARK: Handlers
    @objc
    func handleListChange() {
        
        let alertActionSheetController = UIAlertController(title: "Lists", message: "Select a list ", preferredStyle: .actionSheet)
        
        let favoriteAction = UIAlertAction(title: List.favorites.rawValue, style: .default) { (action) in
            self.setListContents(for: .favorites)
        }
        
        let watchListAction = UIAlertAction(title: List.watchList.rawValue, style: .default) { (action) in
            self.setListContents(for: .watchList)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        
        
        alertActionSheetController.addAction(favoriteAction)
        alertActionSheetController.addAction(watchListAction)
        alertActionSheetController.addAction(cancelAction)
        present(alertActionSheetController, animated: true, completion: nil)
    }
}

// MARK:- Extension To implement DataSource and delegate for tableView

extension ListsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiResponse?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let movie = apiResponse.results[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        cell.textLabel?.text = movie.title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsViewController = MovieDetailsViewController()
        let movie = apiResponse.results[indexPath.row]
        movieDetailsViewController.movie = movie
        present(movieDetailsViewController, animated: true, completion: nil)
    }
    
}

// MARK:- Networking

extension ListsViewController {
    
    func loadContents() {
        apiResponse?.results.removeAll()
        self.tableView.reloadData()
        let listPath: NetworkConstants.ApiPaths = listType == .favorites ? .favoriteList : .watchList
        NetworkManager().response(for: listPath) { (response) in
            guard let data = response.data else { fatalError() }
            guard let apiResponse = try? JSONDecoder().decode(ApiResponse<Movie>.self, from: data) else {print("Something Went Wrong");return}
            self.apiResponse = apiResponse
            self.tableView.reloadData()
        }
    }
}
