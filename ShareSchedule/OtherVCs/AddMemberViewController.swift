//
//  AddMemberViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import Firebase
import CryptoKit

class AddMemberViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var navigationBar: UINavigationBar!
    
    var yotei_id: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = SSColor.lightbrown
        navigationBar.tintColor = SSColor.white
        navigationBar.titleTextAttributes = [.foregroundColor: SSColor.white]
        
        textField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(){
        guard let _ = Auth.auth().currentUser else {
            return
        }
        
        guard let yotei_id = yotei_id else {
            return
        }
        
        SSManager.shared.isYoteiDocumentAvailable(yotei_id: yotei_id, completion: {isAvailable in
            if isAvailable {
                SSManager.shared.getDocumentFromYotei(yotei_id: yotei_id, completion: {data in
                    guard var members = data["members"] as? [String] else {
                        return
                    }
                    let friend_user_id = SSManager.shared.createMailHash(email: self.textField.text)
                    
                    guard !members.contains(friend_user_id) else {
                        let alertController = UIAlertController(title: "すでにグループに入っています", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    
                    members.append(friend_user_id)
                    
                    SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["members": members], completion: {
                        SSManager.shared.isUserDocumentAvailable(user_id: friend_user_id, completion: {isAvailable in
                            if isAvailable{
                                SSManager.shared.getDocumentFromUser(user_id: friend_user_id, completion: {data in
                                    if var yoteis = data["yotei"] as? [String]{
                                        yoteis.append(yotei_id)
                                        SSManager.shared.setDocumentToUser(user_id: friend_user_id, content: ["yotei": yoteis], completion: {
                                            let navigationController = self.presentingViewController as! UINavigationController
                                            let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! YoteiMemberTableViewController
                                            
                                            prevVC.reloadCompletely()
                                            
                                            self.dismiss(animated: true, completion: nil)
                                        })
                                    } else {
                                        let yoteis: [String] = [yotei_id]
                                        SSManager.shared.setDocumentToUser(user_id: friend_user_id, content: ["yotei": yoteis], completion: {
                                            let navigationController = self.presentingViewController as! UINavigationController
                                            let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! YoteiMemberTableViewController
                                            
                                            prevVC.reloadCompletely()
                                            
                                            self.dismiss(animated: true, completion: nil)
                                        })
                                    }
                                })
                            } else {
                                let alertController = UIAlertController(title: "ユーザーが存在しません", message: "", preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(action)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
                    })
                })
            }
        })
    }

}
