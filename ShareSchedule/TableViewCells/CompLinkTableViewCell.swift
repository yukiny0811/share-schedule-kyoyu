//
//  CompLinkTableViewCell.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit

class CompLinkTableViewCell: UITableViewCell , UITextViewDelegate{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.contentView.backgroundColor = .clear
        
        backView.layer.cornerRadius = 10
        backView.backgroundColor = SSColor.yellow
        
        textView.isSelectable = true
        textView.isEditable = false
        textView.delegate = self
        
        self.contentView.backgroundColor = .white
        self.textView.backgroundColor = SSColor.yellow
        self.textView.textColor = SSColor.lightbrown
        self.textView.tintColor = SSColor.lightbrown
        
        backView.layer.shadowOffset = CGSize(width: -2, height: 2)
        backView.layer.shadowColor = SSColor.lightbrown.cgColor
        backView.layer.shadowOpacity = 0.7
        backView.layer.shadowRadius = 4
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataToShow(title: String, text: String){
        
        if let url = URL(string: text){
            if UIApplication.shared.canOpenURL(url){
                let attributedString = NSMutableAttributedString(string: text)

                attributedString.addAttribute(.link,
                                              value: text,
                                              range: NSString(string: text).range(of: text))

                textView.attributedText = attributedString
                
                
                
            }
           
        }

        titleLabel.text = title
       textView.text = text
        
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if UIApplication.shared.canOpenURL(URL){
            UIApplication.shared.open(URL)
        }
        
        return false
    }
    
}
