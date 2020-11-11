//
//  AddCompTextViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/04.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import Firebase

class AddCompTextViewController: AddCompViewController , UITextFieldDelegate{
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var navigationBar: UINavigationBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = SSColor.lightbrown
        navigationBar.tintColor = SSColor.white
        navigationBar.titleTextAttributes = [.foregroundColor: SSColor.white]
        
        titleTextField.delegate = self
    }
    
    @IBAction func cancel(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(){
        
        guard let user = Auth.auth().currentUser else {
            print("error")
            return
        }
        
        guard let yotei_id = self.yotei_id else {
            return
        }
        
        SSManager.shared.isYoteiDocumentAvailable(yotei_id: yotei_id, completion: {isAvailable in
            if isAvailable{
                SSManager.shared.getDocumentFromYotei(yotei_id: yotei_id, completion: {data in
                    let compType = "text"
                    let tempTitle = self.titleTextField.text!
                    let tempText = self.textView.text!
                    
                    let processedString = compType + "å" + tempTitle + "å" + tempText
                    
                    if var blocks = data["blocks"] as? [String]{
                        blocks.append(processedString)
                        SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["blocks": blocks], completion: {
                            self.dismiss(animated: true)
                        })
                    } else {
                        var blocks: [String] = []
                        blocks.append(processedString)
                        SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["blocks": blocks], completion: {
                            self.dismiss(animated: true)
                        })
                    }
                })
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }

}
