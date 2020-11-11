//
//  SettingViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/13.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingViewController: UIViewController {
    
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = SSColor.lightbrown
        navigationBar.tintColor = SSColor.white
        navigationBar.titleTextAttributes = [.foregroundColor: SSColor.white]
        
        logoutButton.backgroundColor = SSColor.yellow
        logoutButton.layer.cornerRadius = 10
        logoutButton.setTitleColor(.black, for: .normal)
        
        deleteButton.backgroundColor = .systemPink
        deleteButton.layer.cornerRadius = 10
        deleteButton.setTitleColor(.black, for: .normal)
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        label.text = user.email!
    }
    
    @IBAction func deleteAccount(){
        
        let user_id = SSManager.shared.createMailHash(email: Auth.auth().currentUser?.email)
        
        SSManager.shared.deleteDocumentFromUsers(user_id: user_id, completion: {
            do{
                try Auth.auth().signOut()
                GIDSignIn.sharedInstance()?.signOut()
            } catch {
                
            }
            
            let navigationController = self.presentingViewController as! UINavigationController
            let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! MainTableViewController
            prevVC.reloadCompletely()
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func logout(){
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
        } catch {
            
        }
        
        let navigationController = self.presentingViewController as! UINavigationController
        let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! MainTableViewController
        prevVC.reloadCompletely()
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func cancel(){
        
        self.dismiss(animated: true, completion: nil)
    }

}
