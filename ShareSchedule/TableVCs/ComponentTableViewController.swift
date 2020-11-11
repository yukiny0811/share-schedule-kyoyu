
//
//  ComponentTableViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/04.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit

class ComponentTableViewController: UITableViewController {
    
    let componentImageNameArray: [String] = ["text.justifyleft", "clock", "link", "location"]
    let componentTitleArray: [String] = ["テキスト", "時刻", "リンク", "場所"]
    let componentDescriptionArray: [String] = ["テキストメモを追加できます", "時刻を追加できます", "リンクを追加できます", "場所を追加できます"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ComponentTableViewCell", bundle: nil), forCellReuseIdentifier: "componentCell")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentImageNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "追加できるブロック"
        }
        return ""
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "componentCell", for: indexPath) as? ComponentTableViewCell{
            
            cell.dataToShow(image: UIImage(systemName: componentImageNameArray[indexPath.row])!, title: componentTitleArray[indexPath.row], description: componentDescriptionArray[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let presentingVC = self.presentingViewController
        
        self.dismiss(animated: true, completion: { () -> Void in
            
            let navigationController = presentingVC as! UINavigationController
            let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! YoteiTableViewController
            let segueIDArray = prevVC.segueIDArray
            prevVC.performSegue(withIdentifier: segueIDArray[indexPath.row], sender: nil)
        })
    }
    
    

}
