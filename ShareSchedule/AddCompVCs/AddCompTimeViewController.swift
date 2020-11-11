//
//  AddCompTimeViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import Firebase

class AddCompTimeViewController: AddCompViewController, UITextFieldDelegate{
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
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
                    let compType = "time"
                    let tempTitle = self.titleTextField.text!
                    let tempTime = self.datePicker.date.toString()!
                   
                    let processedString = compType + "å" + tempTitle + "å" + tempTime
                    
                    if var blocks = data["blocks"] as? [String]{
                        blocks.append(processedString)
                        SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["blocks": blocks], completion: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    } else {
                        var blocks: [String] = []
                        blocks.append(processedString)
                        SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["blocks": blocks], completion: {
                            self.dismiss(animated: true, completion: nil)
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

extension Date{
    func toString() -> String?{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "MM月dd日 hh:mm"
        return formatter.string(from: self)
    }
}
