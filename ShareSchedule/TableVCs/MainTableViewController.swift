//
//  MainTableViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/03.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import Firebase
import CryptoKit
import ViewAnimator

class MainTableViewController: UITableViewController{
    
    var normalYotei: [String] = []
    var archivedYotei: [String] = []
    var normalYoteiID: [String] = []
    var archivedYoteiID: [String] = []
    
    var selectedYoteiID: String?
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "YoteiCellTableViewCell", bundle: nil), forCellReuseIdentifier: "yoteiCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                self.performSegue(withIdentifier: "toSignin", sender: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("123")
        
        if Auth.auth().currentUser == nil{
            performSegue(withIdentifier: "toSignin", sender: nil)
        }
        
        print("456")
        
        guard let user = Auth.auth().currentUser else {
            performSegue(withIdentifier: "toSignin", sender: nil)
            return
        }
        
        let user_id = SSManager.shared.createMailHash(email: user.email)
        
        print("135")
        
        print("sssaaa")
        print(user.displayName)
        print("aaasss")
        
        if let tempDisplayName = user.displayName {
            SSManager.shared.setDocumentToUser(user_id: user_id, content: [
                "name": tempDisplayName
                ], completion: {
                    print("ghgh")
                    self.reloadCompletely()
                }
            )
        } else {
            var str = ""
            for s in user.email!{
                if s == "@"{
                    break
                }
                str += String(s)
            }
            
            SSManager.shared.setDocumentToUser(user_id: user_id, content: [
                "name": str
                ], completion: {
                    print("ghgh")
                    self.reloadCompletely()
                }
            )
        }
        print("345")
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func reloadCompletely(){
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let user_id = SSManager.shared.createMailHash(email: user.email)
        
        normalYotei.removeAll()
        normalYoteiID.removeAll()
        archivedYotei.removeAll()
        archivedYoteiID.removeAll()
        
        print("kkk")
        
        SSManager.shared.isUserDocumentAvailable(user_id: user_id, completion: { isAvailable in
            print("asd")
            if isAvailable{
                SSManager.shared.getDocumentFromUser(user_id: user_id, completion: {data in
                    guard let yoteis = data["yotei"] as? [String] else {
                        print("cnn")
                        SSManager.shared.setDocumentToUser(user_id: user_id, content: ["yotei": []], completion: {
                            print("bbb")
                            self.tableView.reloadData()
                        })
                        return
                    }
                    for yotei in yoteis{
                        SSManager.shared.isYoteiDocumentAvailable(yotei_id: yotei, completion: { isAvailable in
                            if isAvailable{
                                SSManager.shared.getDocumentFromYotei(yotei_id: yotei, completion: {data in
                                    if let tempIsArchived = data["archived"] as? Bool{
                                        if let tempTitle = data["title"] as? String{
                                            if tempIsArchived == false{
                                                self.normalYotei.append(tempTitle)
                                                self.normalYoteiID.append(yotei)
                                            } else {
                                                self.archivedYotei.append(tempTitle)
                                                self.archivedYoteiID.append(yotei)
                                            }
                                            print("aaa")
                                        }
                                    }
                                    print("ccc")
                                    self.tableView.reloadData()
                                })
                            } else {
                                print("ddd")
                                self.tableView.reloadData()
                            }
                        })
                    }
                    self.tableView.reloadData()
                })
            } else {
                print("bbb")
                self.tableView.reloadData()
            }
        })
    }
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = SSColor.yellow
        
        if let header = view as? UITableViewHeaderFooterView{
            header.textLabel?.textColor = SSColor.lightbrown
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return normalYotei.count
        } else if section == 1{
            return archivedYotei.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "これからの予定"
        case 1:
            return "終了した予定"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "yoteiCell", for: indexPath) as? YoteiCellTableViewCell{
            
            guard normalYotei.count > 0 || archivedYotei.count > 0 else {
                return UITableViewCell()
            }
            
            switch indexPath.section {
            case 0:
                cell.dataToShow(image: UIImage(systemName: "scribble")!, title: normalYotei[indexPath.row])
                
//                let storageRef = Storage.storage().reference().child("yotei")
//
//                let imageRef = storageRef.child("image-" + normalYoteiID[indexPath.row])
//
//                let imageData
                return cell
            case 1:
                cell.dataToShow(image: UIImage(systemName: "scribble")!, title: archivedYotei[indexPath.row])
                return cell
            default:
                break
            }
        }
        
        return UITableViewCell()
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard normalYoteiID.count > 0 else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0{
            selectedYoteiID = normalYoteiID[indexPath.row]
        } else if indexPath.section == 1{
            selectedYoteiID = archivedYoteiID[indexPath.row]
        }
        
        performSegue(withIdentifier: "toYoteiVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toYoteiVC"{
            if let nextVC: YoteiTableViewController = segue.destination as? YoteiTableViewController{
                if let selected_yotei_id = selectedYoteiID {
                    nextVC.yotei_id = selected_yotei_id
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            if indexPath.section == 0{
                let alert = UIAlertController(title: "本当にアーカイブしますか？", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { Void in
                    let tempYoteiID = self.normalYoteiID[indexPath.row]
                    SSManager.shared.isYoteiDocumentAvailable(yotei_id: tempYoteiID, completion: {isAvailable in
                        SSManager.shared.setDocumentToYotei(yotei_id: tempYoteiID, content: ["archived": true], completion: {
                            self.reloadCompletely()
                        })
                    })
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
                
            } else if indexPath.section == 1{
                let alert = UIAlertController(title: "本当に削除しますか？", message: "完全に削除されます。この操作は取り消せません。", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { Void in
                    let tempYoteiID = self.archivedYoteiID[indexPath.row]
                    SSManager.shared.isYoteiDocumentAvailable(yotei_id: tempYoteiID, completion: {isAvailable in
                        if isAvailable{
                            SSManager.shared.getDocumentFromYotei(yotei_id: tempYoteiID, completion: {data in
                                if let members = data["members"] as? [String]{
                                    for member in members{
                                        SSManager.shared.isUserDocumentAvailable(user_id: member, completion: {isAvailable in
                                            if isAvailable{
                                                SSManager.shared.getDocumentFromUser(user_id: member, completion: {data in
                                                    if var yoteis = data["yotei"] as? [String]{
                                                        for i in 0..<yoteis.count{
                                                            if yoteis[i] == tempYoteiID{
                                                                yoteis.remove(at: i)
                                                            }
                                                        }
                                                        SSManager.shared.setDocumentToUser(user_id: member, content: ["yotei": yoteis], completion: {
                                                            self.reloadCompletely()
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                    
                                } else {
                                    SSManager.shared.deleteDocumentFromYotei(yotei_id: tempYoteiID, completion: {
                                        self.reloadCompletely()
                                    })
                                }
                           })
                        }
                    })
                    SSManager.shared.deleteDocumentFromYotei(yotei_id: tempYoteiID, completion: {
                        self.reloadCompletely()
                    })
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
