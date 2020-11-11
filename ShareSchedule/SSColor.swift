//
//  SSColor.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit

class SSColor: UIColor {
    
    class override var yellow: UIColor{
        return UIColor(red: 230 / 255.0, green: 200 / 255.0, blue: 140 / 255.0, alpha: 1)
    }
    
    class var lightbrown: UIColor{
        return UIColor(red:  140 / 255.0, green: 100 / 255.0, blue: 60 / 255.0, alpha: 1)
    }
    
    class override var clear: UIColor{
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
}
