//
//  AddCompPlaceViewController.swift
//  ShareSchedule
//
//  Created by Developer Kuwa on 2020/10/18.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AddCompPlaceViewController: AddCompViewController , UITextFieldDelegate, MKMapViewDelegate{

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var mapView: MKMapView!
    
    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = SSColor.lightbrown
        navigationBar.tintColor = SSColor.white
        navigationBar.titleTextAttributes = [.foregroundColor: SSColor.white]
        
        titleTextField.delegate = self
        searchTextField.delegate = self
        
        
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(recognizeLongPress(sender:)))

        self.mapView.addGestureRecognizer(myLongPress)
    }
    
    @objc func recognizeLongPress(sender: UILongPressGestureRecognizer) {

        if sender.state != UIGestureRecognizer.State.began {
            return
        }

        let location = sender.location(in: self.mapView)

        let myCoordinate: CLLocationCoordinate2D = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        self.mapView.removeAnnotations(self.mapView.annotations)

        let myPin = MKPointAnnotation()

        myPin.coordinate = myCoordinate

        myPin.title = searchTextField.text!

        myPin.subtitle = ""

        self.mapView.addAnnotation(myPin)
    }
    
    @IBAction func search(){
        geocoder.geocodeAddressString(searchTextField.text!, completionHandler: {(placemarks, error) in
            if let placemarks = placemarks{
                for placemark in placemarks{
                    if let location = placemark.location{
                        let targetCoordinate = location.coordinate
                        
                        self.mapView.removeAnnotations(self.mapView.annotations)
                        
                        let pin = MKPointAnnotation()
                        pin.coordinate = targetCoordinate
                        pin.title = self.searchTextField.text!
                        self.mapView.addAnnotation(pin)
                        self.mapView.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    }
                }
            }
        })
    }
    
    @IBAction func cancel(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(){
        
        guard let user = Auth.auth().currentUser else {
            print("error")
            return
        }
        
        guard let yotei_id = self.yotei_id else {
            return
        }
        
        
        
        
        
        SSManager.shared.isYoteiDocumentAvailable(yotei_id: yotei_id, completion: {isAvailable in
            if isAvailable{
                SSManager.shared.getDocumentFromYotei(yotei_id: yotei_id, completion: {data in
                    let compType = "place"
                    let tempTitle = self.titleTextField.text!
                    
                    var locationString = ""
                    
                    if self.mapView.annotations.count <= 0{
                        if self.searchTextField.text != nil && self.searchTextField.text != ""{
                            locationString = self.searchTextField.text!
                        } else {
                            let alertController = UIAlertController(title: "何か入力してください", message: "", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                            return
                        }
                    } else {
                        let coord = self.mapView.annotations[0].coordinate
                        locationString = String(coord.latitude) + "¥" + String(coord.longitude)
                    }

                    let processedString = compType + "å" + tempTitle + "å" + locationString

                    if var blocks = data["blocks"] as? [String]{
                        blocks.append(processedString)

                        SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["blocks": blocks], completion: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    } else {
                        var blocks: [String] = []
                        blocks.append(processedString)

                        SSManager.shared.setDocumentToYotei(yotei_id: yotei_id, content: ["blocks": blocks], completion: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                })
            }
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation{
            
        }
        
    }

}
