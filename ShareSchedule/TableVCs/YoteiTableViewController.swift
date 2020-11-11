//
//  YoteiTableViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/03.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import Firebase
import CryptoKit

class YoteiTableViewController: UITableViewController , UIPopoverPresentationControllerDelegate{
    
    /* bhaveshtandel17/MovableTableViewCell */
    var sourceIndexPath: IndexPath?
    var snapshot: UIView?
    //end
    
    var yotei_id: String?
    
    let segueIDArray: [String] = ["toCompText", "toCompTime", "toCompLink", "toCompPlace"]
    
    var blockTypeArray: [String] = []
    var blockTitleArray: [String] = []
    var blockContentArray: [String] = []
    
    /* bhaveshtandel17/MovableTableViewCell */
    @objc func longPressGestureRecognized(longPress: UILongPressGestureRecognizer) {
        let state = longPress.state
        let location = longPress.location(in: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: location) else {
            self.cleanup()
            return
        }
        switch state {
        case .began:
            if indexPath.row == 0{
                return
            }
            sourceIndexPath = indexPath
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
            // Take a snapshot of the selected row using helper method. See below method
            snapshot = self.customSnapshotFromView(inputView: cell)
            guard let snapshot = self.snapshot else { return }
            var center = cell.center
            snapshot.center = center
            snapshot.alpha = 0.0
            self.tableView.addSubview(snapshot)
            UIView.animate(withDuration: 0.25, animations: {
                center.y = location.y
                snapshot.center = center
                snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                snapshot.alpha = 0.98
                cell.alpha = 0.0
            }, completion: { (finished) in
                cell.isHidden = true
            })
            break
        case .changed:
            guard let snapshot = self.snapshot else {
                return
            }
            var center = snapshot.center
            center.y = location.y
            snapshot.center = center
            guard let sourceIndexPath = self.sourceIndexPath  else {
                return
            }
            if indexPath != sourceIndexPath && indexPath.row != 0{
                blockTypeArray.swapAt(indexPath.row, sourceIndexPath.row)
                blockTitleArray.swapAt(indexPath.row, sourceIndexPath.row)
                blockContentArray.swapAt(indexPath.row, sourceIndexPath.row)
                self.tableView.moveRow(at: sourceIndexPath, to: indexPath)
                self.sourceIndexPath = indexPath
            }
            break
        case .ended:
            
            guard let yotei_id = yotei_id else {
                return
            }
            
            SSManager.shared.isYoteiDocumentAvailable(yotei_id: yotei_id, completion: {isAvailable in
                if isAvailable{
                    var processedArray: [String] = []
                    for i in 1..<self.blockTypeArray.count{
                        var tempStr = ""
                        tempStr += self.blockTypeArray[i]
                        tempStr += "å"
                        tempStr += self.blockTitleArray[i]
                        tempStr += "å"
                        tempStr += self.blockContentArray[i]
                        processedArray.append(tempStr)
                    }
                    SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["blocks": processedArray], completion: nil)
                }
            })
            
            guard let cell = self.tableView.cellForRow(at: indexPath) else {
                return
            }
            guard let snapshot = self.snapshot else {
                return
            }
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                snapshot.center = cell.center
                snapshot.transform = CGAffineTransform.identity
                snapshot.alpha = 0
                cell.alpha = 1
            }, completion: { (finished) in
                self.cleanup()
            })
            break
        default:
            guard let cell = self.tableView.cellForRow(at: indexPath) else {
                return
            }
            guard let snapshot = self.snapshot else {
                return
            }
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                snapshot.center = cell.center
                snapshot.transform = CGAffineTransform.identity
                snapshot.alpha = 0
                cell.alpha = 1
            }, completion: { (finished) in
                self.cleanup()
            })
        }
    }
    
    private func cleanup() {
      self.sourceIndexPath = nil
      snapshot?.removeFromSuperview()
      self.snapshot = nil
    }
    
    private func customSnapshotFromView(inputView: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        if let CurrentContext = UIGraphicsGetCurrentContext() {
            inputView.layer.render(in: CurrentContext)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
    //end

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* bhaveshtandel17/MovableTableViewCell */
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(longPress:)))
        self.tableView.addGestureRecognizer(longPress)
        //end
        
        
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "CompTextTableViewCell", bundle: nil), forCellReuseIdentifier: "textCell")
        tableView.register(UINib(nibName: "CompTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "timeCell")
        tableView.register(UINib(nibName: "CompLinkTableViewCell", bundle: nil), forCellReuseIdentifier: "linkCell")
        tableView.register(UINib(nibName: "CompPlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "placeCell")
        tableView.register(UINib(nibName: "CompMembersTableViewCell", bundle: nil), forCellReuseIdentifier: "membersCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadCompletely()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockTypeArray.count
    }
    
    
    func reloadCompletely(){
        
        guard let user = Auth.auth().currentUser else {
            print("error")
            return
        }
        
        guard let yotei_id = yotei_id else {
            return
        }
        
        blockTypeArray.removeAll()
        blockTitleArray.removeAll()
        blockContentArray.removeAll()
        
        blockTypeArray.append("members")
        blockTitleArray.append("members")
        blockContentArray.append("members")
        
        SSManager.shared.isYoteiDocumentAvailable(yotei_id: yotei_id, completion: {isAvailable in
            if isAvailable{
                SSManager.shared.getDocumentFromYotei(yotei_id: yotei_id, completion: {data in
                    if let blocks = data["blocks"] as? [String]{
                        for block in blocks{
                            let splitStringArray: [String] = block.components(separatedBy: "å")
                            if splitStringArray.count >= 3{
                                self.blockTypeArray.append(splitStringArray[0])
                                self.blockTitleArray.append(splitStringArray[1])
                                self.blockContentArray.append(splitStringArray[2])
                            }
                        }
                    }
                    self.tableView.reloadData()
                })
            }
        })
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch blockTypeArray[indexPath.row] {
        case "members":
            let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath) as! CompMembersTableViewCell
            cell.backgroundColor = .gray

            return cell
        case "text":

            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! CompTextTableViewCell
            cell.dataToShow(title: blockTitleArray[indexPath.row], text: blockContentArray[indexPath.row])

            let height = cell.textView.sizeThatFits(CGSize(width: cell.textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
            cell.textView.heightAnchor.constraint(equalToConstant: height).isActive = true
            return cell
        case "time":
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! CompTimeTableViewCell
            cell.dataToShow(title: blockTitleArray[indexPath.row], time: blockContentArray[indexPath.row])
            cell.backgroundColor = .yellow

            return cell
        case "link":
            let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath) as! CompLinkTableViewCell
            cell.dataToShow(title: blockTitleArray[indexPath.row], text: blockContentArray[indexPath.row])
            cell.backgroundColor = .lightGray

            let height = cell.textView.sizeThatFits(CGSize(width: cell.textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
            cell.textView.heightAnchor.constraint(equalToConstant: height).isActive = true
            return cell
        case "place":
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! CompPlaceTableViewCell
            cell.dataToShow(title: blockTitleArray[indexPath.row], location: blockContentArray[indexPath.row])
            cell.backgroundColor = .lightGray
            
            print(cell)
            print(cell.titleLabel.text)
            
            
            
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if blockTypeArray[indexPath.row] == "members"{
            return 70
        } else if blockTypeArray[indexPath.row] == "place"{
            return self.view.frame.width
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            tableView.deselectRow(at: indexPath, animated: true)
            
            performSegue(withIdentifier: "toMember", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segueIDArray.contains(segue.identifier!){
            let nextVC = segue.destination as! AddCompViewController
            nextVC.yotei_id = self.yotei_id
        }
        
        if segue.identifier == "toMember"{
            let nextVC = segue.destination as! YoteiMemberTableViewController
            nextVC.yotei_id = self.yotei_id
        }
    }
    
    
    @IBAction func addComponent(sender: UIBarButtonItem){
        let contentVC = ComponentTableViewController()
        contentVC.modalPresentationStyle = .popover
        contentVC.popoverPresentationController?.barButtonItem = sender
        contentVC.popoverPresentationController?.permittedArrowDirections = .up
        contentVC.popoverPresentationController?.delegate = self
        present(contentVC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0{
            return false
        }
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            
            guard indexPath.row != 0 else {
                return
            }
            
            let alert = UIAlertController(title: "本当に削除しますか？", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { Void in
                guard let yotei_id = self.yotei_id else {
                    return
                }
                SSManager.shared.isYoteiDocumentAvailable(yotei_id: yotei_id, completion: {isAvailable in
                    if isAvailable{
                        SSManager.shared.getDocumentFromYotei(yotei_id: yotei_id, completion: {data in
                            if var blocks = data["blocks"] as? [String]{
                                blocks.remove(at: indexPath.row-1)
                                SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["blocks": blocks], completion: {
                                    self.reloadCompletely()
                                })
                            }
                        })
                    }
                })
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0{
            return false
        }
        return true
    }

}

