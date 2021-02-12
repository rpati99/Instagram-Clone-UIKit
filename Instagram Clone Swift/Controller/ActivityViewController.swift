//
//  NotificationsViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//

import UIKit
import Firebase

class ActivityViewController: UIViewController {
    
    var tableView: UITableView!
    var notifications = [Notifications]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureTableView()
        loadNotifications()
    }
    
    
    // MARK: - API
    func  loadNotifications() {
        guard let currentUser = Auth.auth().currentUser else { return }
        NotificationService.observeNotification(withId: currentUser.uid) { (notification) in
            guard let uid = notification.from else { return }
            print("DBG: \(notification)")
            self.fetchUser(uid: uid) {
                self.notifications.insert(notification, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchUser(uid: String, _ completed: @escaping () -> Void)  {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = User.transformUser(dict: dict, key: snapshot.key)
            self.users.insert(user, at: 0)
            completed()
        }
    }
    // MARK: - Helpers
    
    func configureTableView() {
        navigationItem.title = "Activity"
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(ActivityCell.self, forCellReuseIdentifier: activityCellID)
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
    }
    
 


    

}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activityCellID) as! ActivityCell
        cell.backgroundColor = .white
        cell.notification = notifications[indexPath.row]
        cell.users = users[indexPath.row]
        return cell
    }
    

}
