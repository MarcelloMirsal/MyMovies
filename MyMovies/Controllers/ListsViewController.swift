//
//  ListsViewController.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 06/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

let cellID = "cellId"

protocol EditingMoviesList: class {
    func removeItem(from list: UserList)
}

class ListsViewController: UITableViewController, UITableViewDataSourcePrefetching, EditingMoviesList {
    
    
    // MARK:- Properties
    var apiResponse: ApiResponse<Movie>!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var listType: UserList = .favorites
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        return activityIndicator
    }()
    
    // MARK:- Methods
    fileprivate func setupViews() {
        // MARK: activityIndicator
        guard let headerView = tableView.tableHeaderView else {fatalError()}
        headerView.addSubview(activityIndicator)
        activityIndicator.setConstraint(for: activityIndicator.centerXAnchor, to: headerView.centerXAnchor)
        activityIndicator.setConstraint(for: activityIndicator.centerYAnchor, to: headerView.centerYAnchor)
    }
    
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
        tableView.register(MovieListCell.self, forCellReuseIdentifier: cellID)
        tableView.rowHeight = 136
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView.prefetchDataSource = self
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30) )
        tableView.tableHeaderView = headerView
    }
    
    func setListContents(for type: UserList) {
        if listType == type {return}
        tableView.isUserInteractionEnabled = false
        switch type {
        case .favorites:
            listType = type
            navigationItem.title = listType.rawValue
            apiResponse = nil
            tableView.reloadData()
            updateActivityIndicator(isAnimating: true)
            loadContents()
        case .watchList:
            listType = type
            navigationItem.title = listType.rawValue
            apiResponse = nil
            tableView.reloadData()
            updateActivityIndicator(isAnimating: true)
            loadContents()
        }
        tableView.isUserInteractionEnabled = true
    }
    
    func updateActivityIndicator(isAnimating: Bool) {
        if isAnimating {
            tableView.tableHeaderView?.frame.size.height = 30
            activityIndicator.startAnimating()
        } else {
            tableView.tableHeaderView?.frame.size.height = 0
            activityIndicator.stopAnimating()
        }
    }
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupNavigationBar()
        setupTableView()
        setupViews()
        updateActivityIndicator(isAnimating: true)
        loadContents()
    }
    
    // MARK:- Handlers
    @objc
    func handleListChange() {
        
        let alertActionSheetController = UIAlertController(title: "Lists", message: "Select a list ", preferredStyle: .actionSheet)
        
        let favoriteAction = UIAlertAction(title: UserList.favorites.rawValue, style: .default) { (action) in
            self.setListContents(for: .favorites)
        }
        
        let watchListAction = UIAlertAction(title: UserList.watchList.rawValue, style: .default) { (action) in
            self.setListContents(for: .watchList)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        
        
        alertActionSheetController.addAction(favoriteAction)
        alertActionSheetController.addAction(watchListAction)
        alertActionSheetController.addAction(cancelAction)
        present(alertActionSheetController, animated: true, completion: nil)
    }
}

// MARK:- TableViewDataSource and Delegate Implementation

extension ListsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiResponse?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MovieListCell
        let movie = apiResponse.results[indexPath.row]
        let imageURL = URL(string: URLBuilder.url(for: .image, value: movie.posterPath))
        cell.posterImageView.af_setImage(withURL: imageURL!)
        cell.titleLable.text = movie.title
        cell.subtitleLable.text = Date().customDate(from: movie.releaseDate)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.editingListDelegate = self
        movieDetailsViewController.setupUI(for: listType)
        let movie = apiResponse.results[indexPath.row]
        movieDetailsViewController.movie = movie
        present(movieDetailsViewController, animated: true, completion: nil)
    }
    
}

// MARK:- TableViewPrefetching Implementation
extension ListsViewController {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let posterPathURL = apiResponse.results[indexPath.row].posterPath
            guard let imageURL = URL(string: URLBuilder.url(for: .image, value: posterPathURL)) else {return}
            UIImageView().af_setImage(withURL: imageURL) // to cache the image
            if indexPath.row+1 == apiResponse.results.count {
                loadContents()
            }
        }
    }
}

// MARK:- Editing List Protocol Implementation
extension ListsViewController {
    
    func removeItem(from list: UserList) {
        if list == listType { // only remove cell if the movie is listed in the current movie list
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            apiResponse.results.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

// MARK:- Networking
extension ListsViewController {
    
    func loadContents() {
        let listPath: NetworkConstants.ApiPaths = listType == .favorites ? .favoriteList : .watchList
        
        if let _ = apiResponse {
            if apiResponse.page == apiResponse.totalPages {print("No more data");return}
            NetworkManager().response(for: listPath, at: apiResponse.page+1) { (response) in
                guard let data = response.data else { fatalError() }
                guard let apiResponse = try? JSONDecoder().decode(ApiResponse<Movie>.self, from: data) else {print("Something Went Wrong");return}
                self.apiResponse.results += apiResponse.results
                self.apiResponse.page = apiResponse.page
                self.tableView.reloadData()
            }
        } else {
            NetworkManager().response(for: listPath) { (response) in
                guard let data = response.data else { fatalError() }
                guard let apiResponse = try? JSONDecoder().decode(ApiResponse<Movie>.self, from: data) else {print("Something Went Wrong");return}
                self.apiResponse = apiResponse
                self.updateActivityIndicator(isAnimating: false)
                self.tableView.reloadData()
            }
        }
    }
}
