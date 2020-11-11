//
//  YoteiCellTableViewCell.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/03.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit

class YoteiCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainImageView.tintColor = SSColor.lightbrown
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataToShow(image: UIImage, title: String){
        mainImageView.image = image
        mainLabel.text = title
    }
    
}
