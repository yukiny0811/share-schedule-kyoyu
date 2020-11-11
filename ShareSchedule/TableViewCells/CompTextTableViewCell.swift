//
//  CompTextTableViewCell.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit

class CompTextTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 10
        backView.backgroundColor = SSColor.yellow
        
        textView.isSelectable = true
        textView.isEditable = false
        
        backView.layer.shadowOffset = CGSize(width: -2, height: 2)
        backView.layer.shadowColor = SSColor.lightbrown.cgColor
        backView.layer.shadowOpacity = 0.7
        backView.layer.shadowRadius = 4
        
        
        self.contentView.backgroundColor = .white
        
        self.textView.backgroundColor = SSColor.yellow
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataToShow(title: String, text: String){
        titleLabel.text = title
        textView.text = text
    }
    
}
