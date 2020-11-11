//
//  CompPlaceTableViewCell.swift
//  ShareSchedule
//
//  Created by クワシマ・ユウキ on 2020/10/05.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import MapKit

class CompPlaceTableViewCell: UITableViewCell, MKMapViewDelegate{
    
    @IBOutlet var backView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = .clear
        
        backView.layer.cornerRadius = 10
        backView.backgroundColor = SSColor.yellow
        
        self.contentView.backgroundColor = .white
        
        backView.layer.shadowOffset = CGSize(width: -2, height: 2)
        backView.layer.shadowColor = SSColor.lightbrown.cgColor
        backView.layer.shadowOpacity = 0.7
        backView.layer.shadowRadius = 4
        
        mapView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func dataToShow(image: UIImage, title: String){
//        mainImageView.image = image
//        mainLabel.text = title
//    }
    
    func dataToShow(title: String, location: String){
        
        titleLabel.text = title
        if location.contains("¥"){
            let coordinates = location.components(separatedBy: "¥")
            guard coordinates.count >= 2 else {
                return
            }
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
            pin.title = title
            self.mapView.addAnnotation(pin)
            self.mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!), latitudinalMeters: 500, longitudinalMeters: 500)
        } else {
//            let label = UILabel()
//            label.text = location
//            self.backView.addSubview(label)
        }
        
        
    }
    
}
