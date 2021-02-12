//
//  LoginController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit




class LoginController: UIViewController {
    
    // MARK: - Properties

    private let topLbl: UILabel = {
        let label = UILabel().topLabel(title: "Login", weight: .heavy)
        return label

    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(showMainPage), for: .touchUpInside)
        return button
    }()
    
    private let aboutButton:  UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "more"), for: .normal)
        button.tintColor = .twitterBlue
        button.addTarget(self, action: #selector(showAboutPopup), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().createContainer(image: nil, textField: emailTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().createTextField(placeholder: "Email", isSecureTextEntry: false)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return UIView().createContainer(image: nil, textField: passwordTextField)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().createTextField(placeholder: "Password", isSecureTextEntry: true)
    }()
    
    
    
    private lazy var loginBtn: UIButton = {
  
        let button = UIButton().makeBlackBackgroundButton(title: "Log in")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
      
    }
    
    // MARK: - Selectors
    
    @objc func showAboutPopup() {
        let alert = UIAlertController(title: "About", message: "Instagram clone v1.0", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func showMainPage() {
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func handleLogin() {
        ProgressHUD.show("Waiting...", interaction: false)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
     
        //Login user
        AuthService.shared.loginUser(email: email, password: password) {
            ProgressHUD.showSuccess("Success")
             let newKeywindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            
            guard let tabBarVC = newKeywindow?.rootViewController as? ViewController else { return }
            tabBarVC.performAuthentication()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Touch methods
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       view.endEditing(true)
   }
    
    // MARK: - Helpers
    
    
    func configureUI(){

        Utilities().setLoginButtonOnKeyboard(button: loginBtn, textField: passwordTextField)
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
 
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 5, paddingLeft: 16)
        
        view.addSubview(aboutButton)
        aboutButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 5, paddingRight: 16, width: 28, height: 28)
        
        
        view.addSubview(topLbl)
        topLbl.centerX(inView: view)
        topLbl.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stack.distribution = .fillEqually
        stack.spacing = 20.0
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: topLbl.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 36, paddingLeft: 16)
        
        
        
    }
    
    
    
}
