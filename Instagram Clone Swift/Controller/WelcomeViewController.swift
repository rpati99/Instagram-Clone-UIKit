//
//  WelcomeViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit

class WelcomeController: UIViewController {
    
     //MARK: - Properties

    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textColor = .black
        label.text = "Welcome  \nto \nInstagram."
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    private let createAccountBtn: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Create account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        button.layer.cornerRadius = 23
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(showSignupPage), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAnAccountBtn: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Have an account already? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        attributedTitle.append(NSAttributedString(string: "Log in", attributes: [NSAttributedString.Key.foregroundColor: UIColor.twitterBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showLoginPage), for: .touchUpInside)
        return button
    }()
    
    
     //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        
    }
    
    
    
     //MARK: - Selectors
    
    @objc func showSignupPage() {
        navigationController?.pushViewController(RegistrationController(), animated: true)
    }
    
    @objc func showLoginPage() {
        navigationController?.pushViewController(LoginController(), animated: true)
    }
    
     //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
       
       
        view.addSubview(welcomeLabel)
        welcomeLabel.centerY(inView: view)
        welcomeLabel.anchor(left: view.leftAnchor, paddingLeft: 30)
        
        view.addSubview(createAccountBtn)
        createAccountBtn.anchor(top: welcomeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30,paddingLeft: 37, paddingRight: 37)
        
        view.addSubview(alreadyHaveAnAccountBtn)
        alreadyHaveAnAccountBtn.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 30, paddingBottom: 20)
    }
    
}



