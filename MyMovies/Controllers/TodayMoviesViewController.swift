//
//  TodayMoviesViewController.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 04/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit
import AlamofireImage

let movieCellId = "movieCell"
let headerId = "headerId"

class TodayMoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching, UIViewControllerTransitioningDelegate {
    
    
    // MARK:- Properties
    let preAnimator = PresentationAnimator()
    
    let contentSpacing: CGFloat = 16
    
    var statusBarAppearanceIsHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return statusBarAppearanceIsHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    
    var apiResponse: ApiResponse<Movie>!
    
    let networkManager = NetworkManager()
    
    // MARK:- UI Properties
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        return activityIndicator
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK:- Methods
    func setupAppearance(){
        view.backgroundColor = .white
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: movieCellId)
        collectionView.register(TodayHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: contentSpacing, bottom: 0, right: contentSpacing)
    }
    
    func updateStatusBarAppearance(isHidden : Bool) {
        statusBarAppearanceIsHidden = isHidden
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    func updateActivityIndicator(isAnimating: Bool) {
        if isAnimating {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupCollectionView()
        setupViews()
        updateActivityIndicator(isAnimating: true)
        loadContents()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatusBarAppearance(isHidden: false)
    }

}


// MARK:- Auto Layout Implementation
extension TodayMoviesViewController {
    
    func setupViews(){
        //MARK: collectionView
        view.addSubview(collectionView)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        collectionView.setConstraint(for: collectionView.topAnchor, to: view.topAnchor , constant: statusBarHeight)
        collectionView.setConstraint(for: collectionView.leadingAnchor, to: view.leadingAnchor)
        collectionView.setConstraint(for: collectionView.trailingAnchor, to: view.trailingAnchor)
        collectionView.setConstraint(for: collectionView.bottomAnchor, to: view.bottomAnchor)
        
        //MARK: activityIndicator
        view.addSubview(activityIndicator)
        activityIndicator.setConstraint(for: activityIndicator.centerXAnchor, to: view.centerXAnchor)
        activityIndicator.setConstraint(for: activityIndicator.centerYAnchor, to: view.centerYAnchor)
    }
}

// MARK:- CollectionView DataSource and Delegate Implementation
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
        //cell.popularityLabel.text = "\(movie.voteAverage * 100)%"
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
        // Aspect Ratio 4:3
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
        return CGSize(width: collectionView.frame.width, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieCell
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.transitioningDelegate = self
        
        let rectOfCell = cell.frame
        let rectOfCellInSuperview = collectionView.convert(rectOfCell, to: view)
        
        preAnimator.originFrame = rectOfCellInSuperview
        preAnimator.scaledFrame = view.frame
        
        
        movieDetailsViewController.movie = apiResponse.results[indexPath.row]
        updateStatusBarAppearance(isHidden: true)
        present(movieDetailsViewController, animated: true, completion: nil)
    }
}

// MARK:- CollectionViewPrefetching Implementation
extension TodayMoviesViewController {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let posterPathURL = apiResponse.results[indexPath.row].posterPath
            guard let imageURL = URL(string: URLBuilder.url(for: .image, value: posterPathURL)) else {return}
            UIImageView().af_setImage(withURL: imageURL) // to cache the image
            if indexPath.row+1 == apiResponse.results.count {
                print("Load More COntens")
                loadContents()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}


// MARK:- Networking

extension TodayMoviesViewController {

    func loadContents() {
        if let _ = apiResponse {
            if apiResponse.page == apiResponse.totalPages {print("No more data");return}
            networkManager.response(for: .todayMovies, at: apiResponse.page+1) { (response) in
                guard let data = response.data else { fatalError() }
                guard let apiResponse = try? JSONDecoder().decode(ApiResponse<Movie>.self, from: data) else {print("Something Went Wrong");return}
                self.apiResponse.results += apiResponse.results
                self.apiResponse.page = apiResponse.page
                self.collectionView.reloadData()
            }
        } else {
        networkManager.response(for: .todayMovies) { (response) in
            guard let data = response.data else { fatalError() }
            guard let apiResponse = try? JSONDecoder().decode(ApiResponse<Movie>.self, from: data) else {print("Something Went Wrong");return}
            self.apiResponse = apiResponse
            self.updateActivityIndicator(isAnimating: false)
            self.collectionView.reloadData()
            }
        }
    }
}

// MARK:- Animation
extension TodayMoviesViewController {
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        preAnimator.presenting = true
        return preAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        preAnimator.presenting = false
        return preAnimator
    }
}



class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    var scaledFrame = CGRect.zero
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        if presenting {
            let toView = transitionContext.view(forKey: .to)!
            containerView.addSubview(toView)
            toView.frame = originFrame
            toView.layoutIfNeeded()
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                toView.frame = self.scaledFrame
                toView.layoutIfNeeded()
            }) { (isCompleted) in
                transitionContext.completeTransition(isCompleted)
            }
        }
        else {
            let toView = transitionContext.view(forKey: .to)!
            let fromView = transitionContext.view(forKey: .from)!
            let fromController = transitionContext.viewController(forKey: .from) as! MovieDetailsViewController
            //let toController = (transitionContext.viewController(forKey: .to) as! UITabBarController).viewControllers!.first! as! TodayMoviesViewController
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
            
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75, animations: {
                    fromView.frame = self.originFrame
                    fromController.dismissButtonEffect.alpha = 0.5
                    fromView.layoutIfNeeded()
                })
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1, animations: {
                    //toView.center.y = containerView.center.y
                    fromController.dismissButtonEffect.alpha = 0
                })
            }) { (isCompleted) in
                transitionContext.completeTransition(isCompleted)
            }
        }
        
    }
    
    
}
