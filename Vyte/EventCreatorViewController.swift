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
    @IBOutlet weak var inviteFriendsButton: UIButton!
    
    var invitedFriends: [PFUser]! = []

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "inviteFriendsSegue"{
            let vc = segue.destinationViewController as! InviteFriendsViewController
            vc.invited = invitedFriends
        }

    }
    
    @IBAction func inviteButtonAction(sender: AnyObject){
        performSegueWithIdentifier("inviteFriendsSegue", sender: self)
    }
    
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
        var event = PFObject(className: "Event")
        event["Name"] = nameField.text
        event["Description"]  = descriptionField.text
        event["Address"]  = locationField.text
        event["Location"]  = getCoordinates(locationField.text)
        event["StartTime"]  = datePicker.date
        event["Host"]  = PFUser.currentUser()!.username
        event["Invites"] = invitedFriends.map({$0.objectId!})
        event["Attending"] = []
        event.save()
        
        let vc = self.presentingViewController as! ProfileViewController
        vc.events[0].append(event)
        self.dismissViewControllerAnimated(false, completion: nil)
        println("done")
        
    }
    
    func dateFromString(date: String!) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        println(date)
        println(dateFormatter.dateFromString(date))
        return dateFormatter.dateFromString(date)!
    }
    
    func getCoordinates(address: String!) -> PFGeoPoint {
        var geopoint: PFGeoPoint = PFGeoPoint()
        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks,error) -> Void in
            if (error != nil) {println("error: \(error)")}
            else if let placemark = placemarks?[0] as? CLPlacemark {
                var placemark:CLPlacemark = placemarks[0] as! CLPlacemark
                var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
                println("latitude: \(coordinates.latitude)")
                println("longitude: \(coordinates.longitude)")
                return geopoint = PFGeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
        })
        return geopoint
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
