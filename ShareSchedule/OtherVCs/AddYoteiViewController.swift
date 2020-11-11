//
//  AddYoteiViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/03.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import Firebase
import CryptoKit
import FirebaseAuth

class AddYoteiViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = SSColor.lightbrown
        navigationBar.tintColor = SSColor.white
        navigationBar.titleTextAttributes = [.foregroundColor: SSColor.white]
        
        titleTextField.delegate = self
    }
    
    @IBAction func addYotei(){
        
        let yotei_id = SSManager.shared.createRandomYoteiID()
        
        if titleTextField.text == "" || titleTextField.text == nil{
            let alert = UIAlertController(title: "予定のタイトルを入力してください", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let user_id = SSManager.shared.createMailHash(email: user.email)
        
        SSManager.shared.setDocumentToYotei(yotei_id: yotei_id,
            content: [
                "title": titleTextField.text!,
                "archived": false,
                "members": [user_id]
            ],
            completion: {
                SSManager.shared.isUserDocumentAvailable(user_id: user_id, completion: {available in
                    print("sdfsdf")
                    if available{
                        print("sfsdf")
                        SSManager.shared.getDocumentFromUser(user_id: user_id, completion: {data in
                            guard var yoteiArr = data["yotei"] as? [String] else {
                                SSManager.shared.setDocumentToUser(user_id: user_id, content: ["yotei": [yotei_id]], completion: {
                                    let navigationController = self.presentingViewController as! UINavigationController
                                    let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! MainTableViewController
                                    
                                    do {
                                        try prevVC.reloadCompletely()
                                    } catch SSError.noUserError {
                                        //atode
                                    } catch {
                                        //atode
                                    }
                                    
                                    self.dismiss(animated: true, completion: nil)
                                })
                                return
                            }
                            yoteiArr.append(yotei_id)
                            SSManager.shared.setDocumentToUser(user_id: user_id, content: ["yotei": yoteiArr], completion: {
                                let navigationController = self.presentingViewController as! UINavigationController
                                let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! MainTableViewController
                                
                                do {
                                    try prevVC.reloadCompletely()
                                } catch SSError.noUserError {
                                    //atode
                                } catch {
                                    //atode
                                }
                                
                                self.dismiss(animated: true, completion: nil)
                            })
                        })
                    }
                })
            }
        )
    }
    
    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
