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
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
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
        favoriteButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        favoriteButton.clipsToBounds = true
        return favoriteButton
    }()
    let watchListButton: UIButton = {
        let watchListButton = UIButton()
        watchListButton.setImage(#imageLiteral(resourceName: "Watchlist"), for: .normal)
        watchListButton.translatesAutoresizingMaskIntoConstraints = false
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    var textViewHeightConstraint = NSLayoutConstraint()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK:- Methods
    func setupViews(){
        // MARK:- Auto Layout
        
        
        // MARK: scrollView
        view.addSubview(scrollView)
        scrollView.setConstraint(for: scrollView.topAnchor, to: view.topAnchor)
        scrollView.setConstraint(for: scrollView.leadingAnchor, to: view.leadingAnchor)
        scrollView.setConstraint(for: scrollView.trailingAnchor, to: view.trailingAnchor)
        scrollView.setConstraint(for: scrollView.bottomAnchor, to: view.bottomAnchor)
        
        
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
        // MARK:- contentsView setup
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
        // ratio 16:9
        let width = view.frame.width
        let height = width * 4 / 3
        posterImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        // MARK: movieInfoStackView
        contentsView.addSubview(movieInfoStackView)
        movieInfoStackView.setConstraint(for: movieInfoStackView.topAnchor, to: posterImageView.bottomAnchor)
        movieInfoStackView.setConstraint(for: movieInfoStackView.leadingAnchor, to: posterImageView.leadingAnchor)
        movieInfoStackView.setConstraint(for: movieInfoStackView.trailingAnchor, to: posterImageView.trailingAnchor)
        movieInfoStackView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        
        // MARK: textView
        contentsView.addSubview(textView)
        textView.setConstraint(for: textView.topAnchor, to: movieInfoStackView.bottomAnchor)
        textView.setConstraint(for: textView.leadingAnchor, to: posterImageView.leadingAnchor)
        textView.setConstraint(for: textView.trailingAnchor, to: posterImageView.trailingAnchor)
        textView.setConstraint(for: textView.bottomAnchor, to: contentsView.bottomAnchor)
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 0)
        textViewHeightConstraint.isActive = true
    }
    
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
    
    func setupTextView() {
        guard let movie = self.movie else {return}
        let titles = ["\n\(movie.title)" , "Release Date\n","Overview\n"]
        let subTitles = ["\n \n", "\(movie.releaseDate)\n\n" , "\(movie.overview)"]
        
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
        textViewHeightConstraint.constant = estimatedTextSize.height
    }
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDismissButton()
        setupScrollView()
        setupViews()
        guard let movie = self.movie else {return}
        guard let posterURL = URL(string: URLBuilder.url(for: .image, value: movie.posterPath)) else {fatalError()}
        posterImageView.af_setImage(withURL: posterURL)
        setupTextView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- Handlers
    @objc
    func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaHeight = scrollView.safeAreaInsets.top
        let dismissButtonTopSpace: CGFloat = 16
        let dismissButtonHeight: CGFloat = 15
        let shift = safeAreaHeight + dismissButtonTopSpace + dismissButtonHeight
        if scrollView.contentOffset.y+shift > posterImageView.frame.height && dismissButton.titleColor(for: .normal) == .black {
            print("change to black")
            dismissButton.setTitleColor(.white, for: .normal)
            dismissButtonEffect.effect = UIBlurEffect(style: .dark)
        } else if scrollView.contentOffset.y+shift < posterImageView.frame.height && dismissButton.titleColor(for: .normal) == .white  {
            print("change to light")
            dismissButtonEffect.effect = UIBlurEffect(style: .light)
            dismissButton.setTitleColor(.black, for: .normal)
        }
    }
    
}
