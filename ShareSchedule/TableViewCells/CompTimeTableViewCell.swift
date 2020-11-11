//
//  CompTimeTableViewCell.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit

class CompTimeTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var backView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 10
        backView.backgroundColor = SSColor.yellow
        
        self.contentView.backgroundColor = .white
        
        backView.layer.shadowOffset = CGSize(width: -2, height: 2)
        backView.layer.shadowColor = SSColor.lightbrown.cgColor
        backView.layer.shadowOpacity = 0.7
        backView.layer.shadowRadius = 4
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataToShow(title: String, time: String){
        titleLabel.text = title
        timeLabel.text = time
    }
    
}
