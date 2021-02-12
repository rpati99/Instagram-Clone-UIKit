//
//  SignUpViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    
    
    private let topLbl: UILabel = {
        let label = UILabel().topLabel(title: "Sign up", weight: .heavy)
        return label
    }()
    
    private let plusPhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .twitterBlue
        button.addTarget(self, action: #selector(handleProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "icon_arrow"), for: .normal)
        button.addTarget(self, action: #selector(backToMainPage), for: .touchUpInside)
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
    
    
    
    
    
    private lazy var usernameContainerView: UIView = {
        let view = UIView().createContainer(image: nil, textField: usernameTextField)
        return view
    }()
    
    
    private let usernameTextField: UITextField = {
        return UITextField().createTextField(placeholder: "Username", isSecureTextEntry: false)
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton().makeBlackBackgroundButton(title: "Sign up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    
    
    private let alreadyHaveAnAccountBtn: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.twitterBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        attributedTitle.append(NSAttributedString(string: "Home", attributes: [NSAttributedString.Key.foregroundColor: UIColor.twitterBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showLoginPage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func backToMainPage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleProfilePhoto() {
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
        
        
    }
    
    @objc func showLoginPage() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let profileImage = profileImage else {
            print("DBG: Please select a profile image")
            return
        }
        guard let email = emailTextField.text else { return  }
        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        
        let creds = AuthCredentials(email: email, password: password, username: username, username_lowercased: username.lowercased(), profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: creds) { (error, ref) in
            print("DBG: Data uploaded successfully")
            ProgressHUD.showSuccess("Success")
            
            let newKeywindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            guard let tabBarVC = newKeywindow?.rootViewController as? ViewController else { return }
            tabBarVC.performAuthentication()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    
    // MARK: - Helpers
    func configureUI(){
        
        Utilities().setLoginButtonOnKeyboard(button: signupButton, textField: usernameTextField)
        view.backgroundColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 5, paddingLeft: 16, width: 25, height: 25)
        
        
        
        
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 40, paddingLeft: 16)
        plusPhotoBtn.setDimensions(width: 80, height: 80)
        
        view.addSubview(topLbl)
        
        topLbl.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 35, paddingRight: 16)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, usernameContainerView])
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: plusPhotoBtn.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 36, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(alreadyHaveAnAccountBtn)
        alreadyHaveAnAccountBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        alreadyHaveAnAccountBtn.centerX(inView: view)
        
    }
    
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        plusPhotoBtn.layer.cornerRadius = 80 / 2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.imageView?.contentMode = .scaleAspectFill
        plusPhotoBtn.imageView?.clipsToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.twitterBlue.cgColor
        plusPhotoBtn.layer.borderWidth = 3
        
        guard let pickedImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = pickedImage
        let finalImage = pickedImage.withRenderingMode(.alwaysOriginal)
        plusPhotoBtn.setImage(finalImage, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}
