//
//  SettingsViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 01/02/21.
//

import UIKit
import Firebase

class SettingsViewController: UITableViewController {
    
    // MARK: - Elements
    var user: User?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Selectors
    
    @objc func signOut() {
        AuthService.shared.signOut {
            let welcomeVC = UINavigationController(rootViewController: WelcomeController())
            welcomeVC.modalPresentationStyle = .fullScreen
            self.present(welcomeVC, animated: true, completion: nil)
        }
    }
    
    @objc func changeName() {
        
    }
    
    @objc func changeEmail() {
        
    }
    
    // MARK: - API
    
    func fetchUser() {
        UserService.shared.observeCurrentUser { (user) in
            self.user = user
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Helpers
    func setupUI() {
        tableView.backgroundColor = .systemGray6
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: settingsCellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.tintColor = .black
        
    }
    
}

extension SettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1, 2:
            return 1
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 80
        } else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellID)!
        cell.backgroundColor = .white
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if let profileImageUrl = user?.profileImageUrl {
                    cell.imageView?.setDimensions(width: 80, height: 80)
                    cell.imageView?.layer.cornerRadius = 40
                    cell.imageView?.layer.masksToBounds = true
                    cell.imageView?.centerX(inView: view)
                    
                    cell.imageView?.sd_setImage(with: URL(string: profileImageUrl) , completed: nil)
                }
            case 1:
                cell.textLabel?.text = user?.username
                cell.textLabel?.isUserInteractionEnabled = true
                
            case 2:
                cell.textLabel?.text = user?.email
                cell.textLabel?.isUserInteractionEnabled = true
            default:
                cell.textLabel?.text = ""
            }
        } else if indexPath.section == 1 {
                cell.textLabel?.text = "Save"
            cell.textLabel?.textColor = .blue

        } else if indexPath.section == 2 {
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = .red
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signOut))
            cell.addGestureRecognizer(tapGesture)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.selectionStyle = .none
        
    }
}
