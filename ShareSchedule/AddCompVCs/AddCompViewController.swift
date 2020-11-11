//
//  AddCompViewController.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit

class AddCompViewController: UIViewController {
    var yotei_id: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
        let navigationController = self.presentingViewController as! UINavigationController
        let prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1] as! YoteiTableViewController
        
        prevVC.reloadCompletely()
        
        super.dismiss(animated: flag, completion: completion)
    }
}
