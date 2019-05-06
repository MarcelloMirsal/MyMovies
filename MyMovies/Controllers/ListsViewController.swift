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
        switch type {
        case .favorites:
            listType = type
            navigationItem.title = listType.rawValue
        case .watchList:
            listType = type
            navigationItem.title = listType.rawValue
        }
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupNavigationBar()
        setupTableView()
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
        
        alertActionSheetController.addAction(favoriteAction)
        alertActionSheetController.addAction(watchListAction)
        present(alertActionSheetController, animated: true, completion: nil)
    }
}

// MARK:- Extension To implement DataSource and delegate for tableView

extension ListsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.imageView?.image = #imageLiteral(resourceName: "poster")
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        cell.textLabel?.text = "CREED II"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsViewController = MovieDetailsViewController()
        present(movieDetailsViewController, animated: true, completion: nil)
    }
}
