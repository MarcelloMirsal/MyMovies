//
//  MovieDetailsViewController.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 05/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController, UIScrollViewDelegate  {
    
    // MARK:- Properties
    var movie: Movie?
    
    let networkManager = NetworkManager()
    weak var editingListDelegate: EditingMoviesList?
    
    var isFavorited: Bool {
        if favoriteButton.tintColor == .black {
            return false
        } else {
            return true
        }
    }
    
    var isWatchlisted: Bool {
        if watchListButton.tintColor == .black {
            return false
        } else {
            return true
        }
    }
    
    var textViewHeightConstraint = NSLayoutConstraint()
    var movieTitleHeightConstraint = NSLayoutConstraint()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK:- UI Properties
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.shadowColor = UIColor.lightGray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 20)
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 20
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-Heavy", size: 26)
        label.backgroundColor = .white
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("X", for: .normal)
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Avenir-Medium", size: 18)
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    lazy var dismissButtonEffect = UIVisualEffectView()
    
    let favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(#imageLiteral(resourceName: "star").withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.clipsToBounds = true
        favoriteButton.tintColor = .black
        return favoriteButton
    }()
    
    let watchListButton: UIButton = {
        let watchListButton = UIButton()
        watchListButton.translatesAutoresizingMaskIntoConstraints = false
        watchListButton.setImage(#imageLiteral(resourceName: "Watchlist").withRenderingMode(.alwaysTemplate), for: .normal)
        watchListButton.tintColor = .black
        return watchListButton
    }()
    
    let playButton: UIButton = {
        let playButton = UIButton()
        playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        return playButton
    }()
    
    lazy var movieInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favoriteButton , watchListButton , playButton])
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK:- Methods
    func setupDismissButton(){
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    func setupDismissButtonVisualEffect(with blurEffect: UIBlurEffect = UIBlurEffect(style: .light) ) -> UIVisualEffectView {
        let effect = UIVisualEffectView(effect: blurEffect)
        effect.layer.cornerRadius = 15
        effect.clipsToBounds = true
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }
    
    func setupMovieInfo() {
        guard let movie = self.movie else {return}
        let titles = ["Popularity\n" ,"Release Date\n","Overview\n"]
        let subTitles = ["\(movie.voteAverage * 10)%\n\n","\(movie.releaseDate)\n\n" , "\(movie.overview)"]
        
        let textViewAttributedText = NSMutableAttributedString()
        
        for index in 0...titles.count-1 {
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 24)!]
            let titleAttributedString = NSAttributedString(string: titles[index], attributes: titleAttributes)
            
            let subTitleAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 18)!]
            let subTitleAttributedString = NSAttributedString(string: subTitles[index], attributes: subTitleAttributes)
    
            textViewAttributedText.append(titleAttributedString)
            textViewAttributedText.append(subTitleAttributedString)
        }
        let estimatedTextSize = textViewAttributedText.boundingRect(with: .init(width: 300, height: 0), options: .usesLineFragmentOrigin, context: nil)
        textView.attributedText = textViewAttributedText
        textViewHeightConstraint.constant = estimatedTextSize.height + 16
        
        movieTitleLabel.text = movie.title
        let movieTitleAttributedText = movieTitleLabel.attributedText!
        let estimatedTitleTextSize = movieTitleAttributedText.boundingRect(with: .init(width: 300, height: 0), options: .usesLineFragmentOrigin, context: nil)
        movieTitleHeightConstraint.constant = estimatedTitleTextSize.height
    }
    
    func setupHandlers() {
        favoriteButton.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        watchListButton.addTarget(self, action: #selector(handleWatchlist), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(handlePlayTrailer), for: .touchUpInside)
    }
    
    func presentContents() {
        guard let movie = self.movie else {return}
        guard let posterURL = URL(string: URLBuilder.url(for: .image, value: movie.posterPath)) else {fatalError()}
        
        posterImageView.af_setImage(withURL: posterURL) { (dataResponse) in
            guard let image = dataResponse.value else {return}
            self.posterImageView.image = image
            self.scrollView.backgroundColor = image.averageColor ?? .white
        }
    }
    
    func setupAppearance() {
        view.backgroundColor = .white
    }
    
    func setupUI(for list: UserList) {
        switch list {
        case .favorites:
            favoriteButton.tintColor = .red
        case .watchList:
            watchListButton.tintColor = .red
        }
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAppearance()
        setupDismissButton()
        setupHandlers()
        presentContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMovieInfo()
    }
    
    //MARK:- Handlers
    @objc
    func handleDismiss(){
        scrollView.contentOffset.y = 0
        if !self.isFavorited {
            self.editingListDelegate?.removeItem(from: .favorites)
        }
        if !self.isWatchlisted {
            self.editingListDelegate?.removeItem(from: .watchList)
        }
        dismiss(animated: true)
    }
    
    @objc
    func handleFavorite(){
        guard let movie = self.movie else {return}
        let requestAlertController = UIAlertController(message: "Please Wait")
        self.favoriteButton.isEnabled = false
        present(requestAlertController, animated: true) {
            self.networkManager.mark("\(movie.id)", in: .favorites, with: !self.isFavorited) { (isCompleted, error) in
                if isCompleted && error == nil {
                    self.favoriteButton.tintColor = self.isFavorited ? .black : .red
                    requestAlertController.title = "Done"
                } else {
                    self.favoriteButton.tintColor = .black
                }
                self.favoriteButton.isEnabled = true
                requestAlertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc
    func handleWatchlist(){
        guard let movie = self.movie else {return}
        let requestAlertController = UIAlertController(message: "Please Wait")
        self.watchListButton.isEnabled = false
        present(requestAlertController, animated: true) {
            self.networkManager.mark("\(movie.id)", in: .watchList, with: !self.isWatchlisted) { (isCompleted, error) in
                if isCompleted && error == nil {
                    self.watchListButton.tintColor = self.isWatchlisted ? .black : .red
                    requestAlertController.title = "Done"
                } else {
                    self.watchListButton.tintColor = .black
                }
                self.watchListButton.isEnabled = true
                requestAlertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc
    func handlePlayTrailer() {
        guard let movie = self.movie else {return}
        networkManager.response(for: .watchTrailer, value: "\(movie.id)") { (dataResponse) in
            guard let data = dataResponse.data else {return}
            guard let responseDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String,Any> else {return}
            guard let videosResults = responseDict["results"] as? Array<Any> else {return}
            guard let movieTrailerDict = videosResults[0] as? Dictionary<String,Any> else {return}
            guard let videoKey = movieTrailerDict["key"] as? String else {return}
            print(videoKey)
            let url = URLBuilder.url(for: .youtubeVideo, value: videoKey)
            let videoURL = URL(string: url)!
            UIApplication.shared.open(videoURL, options: [:], completionHandler: nil)
        }
    }
}


// MARK:- Auto Layout Implementation
extension MovieDetailsViewController {
    
    func setupViews(){
        // MARK: scrollView
        view.addSubview(scrollView)
        scrollView.setConstraint(for: scrollView.topAnchor, to: view.topAnchor)
        scrollView.setConstraint(for: scrollView.leadingAnchor, to: view.leadingAnchor)
        scrollView.setConstraint(for: scrollView.trailingAnchor, to: view.trailingAnchor)
        scrollView.setConstraint(for: scrollView.bottomAnchor, to: view.bottomAnchor)
        setupScrollView()
        
        
        //MARK: dismissButtonVisualEffect
        dismissButtonEffect = setupDismissButtonVisualEffect()
        view.addSubview(dismissButtonEffect)
        dismissButtonEffect.setConstraint(for: dismissButtonEffect.topAnchor, to: view.safeAreaLayoutGuide.topAnchor,constant: 16)
        dismissButtonEffect.setConstraint(for: dismissButtonEffect.trailingAnchor, to: view.trailingAnchor,constant: -16)
        dismissButtonEffect.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButtonEffect.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        //MARK: dismissButton
        dismissButtonEffect.contentView.addSubview(dismissButton)
        dismissButton.setConstraint(for: dismissButton.leadingAnchor, to: dismissButtonEffect.contentView.leadingAnchor)
        dismissButton.setConstraint(for: dismissButton.trailingAnchor, to: dismissButtonEffect.contentView.trailingAnchor)
        dismissButton.setConstraint(for: dismissButton.topAnchor, to: dismissButtonEffect.contentView.topAnchor)
        dismissButton.setConstraint(for: dismissButton.bottomAnchor, to: dismissButtonEffect.contentView.bottomAnchor)
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        // MARK: contentsView setup
        scrollView.addSubview(contentsView)
        contentsView.setConstraint(for: contentsView.topAnchor, to: scrollView.topAnchor)
        contentsView.setConstraint(for: contentsView.leadingAnchor, to: scrollView.leadingAnchor)
        contentsView.setConstraint(for: contentsView.trailingAnchor, to: scrollView.trailingAnchor)
        contentsView.setConstraint(for: contentsView.bottomAnchor, to: scrollView.bottomAnchor)
        let heightConstraint = contentsView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        contentsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        // MARK: posterImageView
        contentsView.addSubview(posterImageView)
        posterImageView.setConstraint(for: posterImageView.topAnchor, to: contentsView.topAnchor)
        posterImageView.setConstraint(for: posterImageView.leadingAnchor, to: contentsView.leadingAnchor)
        posterImageView.setConstraint(for: posterImageView.trailingAnchor, to: contentsView.trailingAnchor)
        // ratio 4:3
        let contentSpacing: CGFloat = 16.0
        let width = view.frame.width - (contentSpacing * 2.0)
        let height = width * 4 / 3
        let posterImageHeight = posterImageView.heightAnchor.constraint(equalToConstant: height)
        posterImageHeight.isActive = true
        
        // MARK: movieInfoStackView
        contentsView.addSubview(movieInfoStackView)
        movieInfoStackView.setConstraint(for: movieInfoStackView.topAnchor, to: posterImageView.bottomAnchor)
        movieInfoStackView.setConstraint(for: movieInfoStackView.leadingAnchor, to: posterImageView.leadingAnchor)
        movieInfoStackView.setConstraint(for: movieInfoStackView.trailingAnchor, to: posterImageView.trailingAnchor)
        movieInfoStackView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        // MARK: movieTitle
        contentsView.addSubview(movieTitleLabel)
        movieTitleLabel.setConstraint(for: movieTitleLabel.topAnchor, to: movieInfoStackView.bottomAnchor, constant: 8)
        movieTitleLabel.setConstraint(for: movieTitleLabel.leadingAnchor, to: movieInfoStackView.leadingAnchor, constant: 16)
        movieTitleLabel.setConstraint(for: movieTitleLabel.trailingAnchor, to: movieInfoStackView.trailingAnchor, constant: -16)
        
        movieTitleHeightConstraint =  movieTitleLabel.heightAnchor.constraint(equalToConstant: 0)
        movieTitleHeightConstraint.isActive = true
        
        
        // MARK: textView
        contentsView.addSubview(textView)
        textView.setConstraint(for: textView.topAnchor, to: movieTitleLabel.bottomAnchor)
        textView.setConstraint(for: textView.leadingAnchor, to: posterImageView.leadingAnchor, constant: 16)
        textView.setConstraint(for: textView.trailingAnchor, to: posterImageView.trailingAnchor, constant: -16)
        textView.setConstraint(for: textView.bottomAnchor, to: contentsView.bottomAnchor)
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 0)
        textViewHeightConstraint.isActive = true
    }
}

// MARK:- ScrollViewDelegate Implementation
extension MovieDetailsViewController {
    
    ///This method used to change dismissButton blur effect when scrolling to movie info.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaHeight = scrollView.safeAreaInsets.top
        let dismissButtonTopSpace: CGFloat = 16
        let dismissButtonHeight: CGFloat = 15
        let shift = safeAreaHeight + dismissButtonTopSpace + dismissButtonHeight
        if scrollView.contentOffset.y+shift > posterImageView.frame.height && dismissButton.titleColor(for: .normal) == .black {
            dismissButton.setTitleColor(.white, for: .normal)
            dismissButtonEffect.effect = UIBlurEffect(style: .dark)
        } else if scrollView.contentOffset.y+shift < posterImageView.frame.height && dismissButton.titleColor(for: .normal) == .white  {
            dismissButtonEffect.effect = UIBlurEffect(style: .light)
            dismissButton.setTitleColor(.black, for: .normal)
        }
    }
}
