//
//  LoginViewController.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 04/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    // MARK:- UI Properties
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        return button
    }()
    
    // MARK:- Methods
    private func setupAppearance(){
        view.backgroundColor = .white
    }
    private func setupHandlers(){
        loginButton.addTarget(self, action: #selector(loginHandler(button:)), for: .touchUpInside)
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        setupHandlers()
    }
    
    //MARK:- Handlers
    fileprivate func presentTabBarViewController() {
        let todayViewController = TodayMoviesViewController()
        let listsViewController = ListsViewController()
        let searchViewController = SearchViewController()
        
        let listsNavigationController = UINavigationController(rootViewController: listsViewController)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        
        todayViewController.tabBarItem = UITabBarItem(title: "Today", image: nil, tag: 0)
        listsViewController.tabBarItem = UITabBarItem(title: "Lists", image: nil, tag: 0)
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [todayViewController , listsNavigationController , searchNavigationController]
        
        present(tabBarController, animated: true, completion: nil)
    }
    
    @objc
    private func loginHandler(button: UIButton) {
        
        NetworkManager().session(username: NetworkConstants.demoUser, password: NetworkConstants.demoPassword ) { (isSuccedd, error) in
            if isSuccedd && error == nil {
                self.presentTabBarViewController()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}


extension LoginViewController {
    //MARK: Auto Layout
    func setupLayout(){
        // MARK: usernameTextField
        
        view.addSubview(usernameTextField)
        usernameTextField.setConstraint(for: usernameTextField.topAnchor, to: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        usernameTextField.setConstraint(for: usernameTextField.leadingAnchor, to: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        usernameTextField.setConstraint(for: usernameTextField.trailingAnchor, to: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        usernameTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // MARK: passwordTextField
        
        view.addSubview(passwordTextField)
        passwordTextField.setConstraint(for: passwordTextField.topAnchor, to: usernameTextField.bottomAnchor,constant: 8)
        passwordTextField.setConstraint(for: passwordTextField.leadingAnchor, to: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        passwordTextField.setConstraint(for: passwordTextField.trailingAnchor, to: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        passwordTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // MARK: loginButton
        view.addSubview(loginButton)
        loginButton.setConstraint(for: loginButton.topAnchor, to: passwordTextField.bottomAnchor,constant: 32)
        loginButton.setConstraint(for: loginButton.leadingAnchor, to: passwordTextField.leadingAnchor)
        loginButton.setConstraint(for: loginButton.trailingAnchor, to: passwordTextField.trailingAnchor)
        loginButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
}
