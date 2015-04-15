//
//  FirstViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 3/24/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit
import MapKit

class EventsMapViewController: UIViewController, MKMapViewDelegate, FBRequestConnectionDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var events : [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
        showEventsAsPins()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewEventFromMap" {
            let pin = sender as! MKAnnotation
            let event = events.filter({(e: Event) in e.name == pin.title}).first!
            let vc = segue.destinationViewController as! GuestEventViewController
            vc.eName = event.name
            vc.eTime = event.start_time.description
            vc.eLocation = event.location.description
            vc.eDescription = event.description
            vc.invitees = [event.getAttendingUsers().map({$0.username!}),[],[]]

        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        let pin = view.annotation
        performSegueWithIdentifier("viewEventFromMap", sender: pin)
    }
    
    func showEventsAsPins(){
        let location : PFGeoPoint = PFGeoPoint(location: mapView.userLocation.location)
        let results = (PFQuery(className: "Event").whereKey("Location", geopoint: location, maxDistance: 10.0).findObjects())!
        for obj in results {
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
            pin.title = obj["Name"]
            pin.subtitle = obj["StartTime"].description
            mapView.addAnnotation(pin)
            events.append(Event(name: obj["Name"] as! String, description: obj["Description"] as! String, address: obj["Address"] as! String, location: obj["Location"] as! PFGeoPoint, start_time: obj["StartTime"] as! NSDate))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    func showDemoEvents(){
        
        var eventPinA = MKPointAnnotation()
        eventPinA.coordinate = CLLocationCoordinate2DMake(42.359184, -71.093544)
        eventPinA.title = "Demo"
        eventPinA.subtitle = "4/7/2015 8:00PM"
        mapView.addAnnotation(eventPinA)
        
        var eventPinB = MKPointAnnotation()
        eventPinB.coordinate = CLLocationCoordinate2DMake(42.3561172, -71.09722090)
        eventPinB.title = "Kappa Sigma Dinner"
        eventPinB.subtitle = "4/7/2015 7:20PM"
        mapView.addAnnotation(eventPinB)
        
        var eventPinC = MKPointAnnotation()
        eventPinC.coordinate = CLLocationCoordinate2DMake(42.3630706, -71.0862851)
        eventPinC.title = "Chipotle Burrito-Eating Contest"
        eventPinC.subtitle = "4/7/2015 7:30PM"
        mapView.addAnnotation(eventPinC)
    }

    func showNearbyEvents() {
        let currentLocation = mapView.userLocation.coordinate
        //radius = 50 m
        //results limit = 25
        //search text = nil
        FBRequestConnection.startForPlacesSearchAtCoordinate(currentLocation,radiusInMeters: 50,resultsLimit: 25,searchText: nil,completionHandler: {(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) in
            if(error != nil){
                NSLog("Error getting nearby events: \(error)");
            }
            //TODO: Create and dsiplay annotations for each event
            //var event = MKPointAnnotation()
            //event.setCoordinate()
            //event.title = ""
            //mapView.addAnnotation(event)
            NSLog("\(result)")
        })
    }*/

}

