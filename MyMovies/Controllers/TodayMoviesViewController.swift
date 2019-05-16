//
//  TodayMoviesViewController.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 04/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

let movieCellId = "movieCell"
let headerId = "headerId"

class TodayMoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UI Properties
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let contentSpacing: CGFloat = 16
    
    var statusBarAppearanceIsHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return statusBarAppearanceIsHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    var apiResponse: ApiResponse<Movie>!
    
    // MARK:- Methods
    func setupAppearance(){
        view.backgroundColor = .white
    }
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: movieCellId)
        collectionView.register(TodayHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: contentSpacing, bottom: 0, right: contentSpacing)
        collectionView.panGestureRecognizer.addTarget(self, action: #selector(handle(gesture:)))
    }
    
    func updateStatusBarAppearance(isHidden : Bool) {
        statusBarAppearanceIsHidden = isHidden
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupCollectionView()
        setupViews()
        loadContents()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatusBarAppearance(isHidden: false)
    }
    
    
    // MARK:- Handlers
    // Bouncing animation when draggin cell for scrolling action
    @objc
    func handle(gesture:UIPanGestureRecognizer){
        /* let cellLocation = gesture.location(in: collectionView)
        switch gesture.state {
        case .began:
            for cell in collectionView.visibleCells {
                if cell.frame.contains(cellLocation) {
                    UIView.animateKeyframes(withDuration: 0.75, delay: 0, options: [], animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                        })
                        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: {
                            cell.transform = CGAffineTransform.identity
                        })
                    }, completion: nil)
                }
            }
        default:
            break
        } */
    }

}


// MARK:- Auto Layout

extension TodayMoviesViewController {
    
    func setupViews(){
        //MARK: collectionView
        view.addSubview(collectionView)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        collectionView.setConstraint(for: collectionView.topAnchor, to: view.topAnchor , constant: statusBarHeight)
        collectionView.setConstraint(for: collectionView.leadingAnchor, to: view.leadingAnchor)
        collectionView.setConstraint(for: collectionView.trailingAnchor, to: view.trailingAnchor)
        collectionView.setConstraint(for: collectionView.bottomAnchor, to: view.bottomAnchor)
    }
}

// MARK:- Implementing CollectionView DataSource and Delegate

extension TodayMoviesViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiResponse?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellId, for: indexPath) as! MovieCell
        let movie = apiResponse.results[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.dateLabel.text = Date().customDate(from: movie.releaseDate)
        cell.posterImageView.image = nil
        cell.genreLabel.text = ""
        guard let posterURL = URL(string: URLBuilder.url(for: .image, value: movie.posterPath)) else {fatalError()}
        cell.posterImageView.af_setImage(withURL: posterURL)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - (contentSpacing * 2)
        let height = width * 4 / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return contentSpacing * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movie = apiResponse.results[indexPath.row]
        updateStatusBarAppearance(isHidden: true)
        present(movieDetailsViewController, animated: true, completion: nil)
    }
}


// MARK:- Networking

extension TodayMoviesViewController {

    func loadContents() {
        NetworkManager().response(for: .todayMovies) { (response) in
            guard let data = response.data else { fatalError() }
            guard let apiResponse = try? JSONDecoder().decode(ApiResponse<Movie>.self, from: data) else {print("Something Went Wrong");return}
            self.apiResponse = apiResponse
            self.collectionView.reloadData()
        }
    }
}
