//
//  ViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit
import Firebase

class ViewController: UITabBarController {
    
    
     //MARK: - Elements
    

     //MARK: - Application lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        performAuthentication()

       
    }
    
     //MARK: - Selector functions



    
    
     //MARK: - Methods
    
    func performAuthentication() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: WelcomeController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        } else {
            setupUI()
        }
    }
   
    func setupUI() {
        let nav1 = configureTabBarControllers(image: #imageLiteral(resourceName: "home"),rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        let nav2 = configureTabBarControllers(image: #imageLiteral(resourceName: "search"),rootViewController: ExploreViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        let nav3 = configureTabBarControllers(image: #imageLiteral(resourceName: "add"),rootViewController: CameraViewController())
        let nav4 = configureTabBarControllers(image: #imageLiteral(resourceName: "heart"),rootViewController: ActivityViewController())
        let nav5 = configureTabBarControllers(image: #imageLiteral(resourceName: "user-selected"),rootViewController: ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
      
    }
    
    func configureTabBarControllers(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        
        return nav
    }

    

}

