//
//  EventCreatorViewController.swift
//  Vyte
//
//  Created by Matthew Miklasevich on 4/12/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import Foundation
import MapKit

class EventCreatorViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerAction(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        var date = dateFormatter.stringFromDate(datePicker.date)
        self.selectedDate.text = date
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        println("cancel")
    }
    
    @IBAction func done(sender: AnyObject) {
        println("name: \(nameField.text)")
        println("location: \(locationField.text)")
        println("description: \(descriptionField.text)")
        println("date: \(selectedDate.text)")
        
        CLGeocoder().geocodeAddressString(locationField.text, completionHandler: {(placemarks,error) -> Void in
            if (error != nil) {println("error: \(error)")}
            else if let placemark = placemarks?[0] as? CLPlacemark {
                var placemark:CLPlacemark = placemarks[0] as! CLPlacemark
                var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
                println("latitude: \(coordinates.latitude)")
                println("longitude: \(coordinates.longitude)")
                var geopoint = PFGeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
        })
        self.dismissViewControllerAnimated(false, completion: nil)
        println("done")
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        locationField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        nameField.resignFirstResponder()
        locationField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
