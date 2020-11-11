//
//  ComponentTableViewCell.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/04.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit

class ComponentTableViewCell: UITableViewCell {
    
    @IBOutlet var componentImageView: UIImageView!
    @IBOutlet var componentTitleLabel: UILabel!
    @IBOutlet var componentDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        componentImageView.tintColor = SSColor.lightbrown
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataToShow(image: UIImage, title: String, description: String){
        componentImageView.image = image
        componentTitleLabel.text = title
        componentDescriptionLabel.text = description
    }
    
}
