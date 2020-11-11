//
//  YoteiMemberTableViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import Firebase
import CryptoKit

class YoteiMemberTableViewController: UITableViewController {
    
    var yotei_id: String?
    
    var memberList: [String] = []
    var memberIDList: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.textLabel?.text = memberList[indexPath.row]
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadCompletely()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addMember"{
            let nextVC = segue.destination as! AddMemberViewController
            nextVC.yotei_id = self.yotei_id
        }
    }
    
    func reloadCompletely(){
        memberList.removeAll()
        
        guard let yotei_id = yotei_id else {
            return
        }
        
        SSManager.shared.isYoteiDocumentAvailable(yotei_id: yotei_id, completion: {isAvailable in
            if isAvailable{
                SSManager.shared.getDocumentFromYotei(yotei_id: yotei_id, completion: {data in
                    if let members = data["members"] as? [String]{
                        for member in members{
                            SSManager.shared.isUserDocumentAvailable(user_id: member, completion: {isAvailable in
                                if isAvailable{
                                    SSManager.shared.getDocumentFromUser(user_id: member, completion: {data in
                                        if let name = data["name"] as? String{
                                            self.memberList.append(name)
                                        } else {
                                            self.memberList.append(member)
                                        }
                                        self.memberIDList.append(member)
                                        self.tableView.reloadData()
                                    })
                                }
                            })
                        }
                    }
                })
            }
        })
    }
    
    
    @IBAction func add(){
        
        performSegue(withIdentifier: "addMember", sender: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let member_id = memberIDList[indexPath.row]
            guard let yotei_id = self.yotei_id else {
                return
            }
            
            let alert = UIAlertController(title: "本当に削除しますか？", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { Void in
                SSManager.shared.isYoteiDocumentAvailable(yotei_id: yotei_id, completion: {isAvailable in
                    if isAvailable{
                        SSManager.shared.getDocumentFromYotei(yotei_id: yotei_id, completion: {data in
                            guard var members = data["members"] as? [String] else {
                                return
                            }
                            print(members)
                            
                            for i in 0..<members.count{
                                print(i)
                                if members[i] == member_id{
                                    print("testNNN")
                                    members.remove(at: i)
                                    break
                                }
                            }
                            print("testBBB")
                            SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["members": members], completion: {
                                SSManager.shared.isUserDocumentAvailable(user_id: member_id, completion: {isAvailable in
                                    if isAvailable{
                                        print("testVVV")
                                        SSManager.shared.getDocumentFromUser(user_id: member_id, completion: {data in
                                            guard var yoteis = data["yotei"] as? [String] else {
                                                return
                                            }
                                            print("testAAA")
                                            for i in 0..<yoteis.count{
                                                if yoteis[i] == yotei_id{
                                                    yoteis.remove(at: i)
                                                }
                                            }
                                            SSManager.shared.setDocumentToUser(user_id: member_id, content: ["yotei": yoteis], completion: {
                                                
                                                
                                                self.reloadCompletely()
                                                
                                                
                                                
                                            })
                                        })
                                    }
                                })
                            })
                        })
                    }
                })
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
