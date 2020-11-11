//
//  CompMembersTableViewCell.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit

class CompMembersTableViewCell: UITableViewCell {
    
    @IBOutlet var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = .white
        
        self.backView.backgroundColor = SSColor.yellow
        
        backView.layer.shadowOffset = CGSize(width: -2, height: 2)
        backView.layer.shadowColor = SSColor.lightbrown.cgColor
        backView.layer.shadowOpacity = 0.7
        backView.layer.shadowRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
