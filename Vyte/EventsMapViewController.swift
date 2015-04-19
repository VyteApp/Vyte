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
    
    var events : [PFObject] = []
    
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
            let event = events.filter({(e: PFObject) in e.objectForKey("Name") as? String == pin.title}).first!
            let vc = segue.destinationViewController as! GuestEventViewController
            vc.event = event
            vc.invitees[0] = PFUser.query()!.whereKey("objectId", containedIn: event["Attending"] as![String]).findObjects() as! [PFUser]
            vc.invitees[1] = []
            vc.invitees[2] = PFUser.query()!.whereKey("objectId", containedIn: event["Invites"] as![String]).findObjects() as! [PFUser]
            //vc.invitees[1] = vc.invitees[2].filter({!contains(vc.invitees[0],$0)})
        }
    }
    
   // func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
   //     showEventsAsPins()
   //}
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        let pin = view.annotation
        if !pin.isEqual(mapView.userLocation as MKAnnotation){
            self.performSegueWithIdentifier("viewEventFromMap", sender: pin)
        }
    }
    
    func showEventsAsPins(){
        let location : PFGeoPoint = PFGeoPoint(location: mapView.userLocation.location)
        println(location)
        let query = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location)
        query.findObjectsInBackgroundWithBlock({(results, error) -> Void in
            for obj in (results! as! [PFObject]) {
                println(obj)
                let pin = MKPointAnnotation()
                let location = obj.objectForKey("Location") as! PFGeoPoint
                pin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                pin.title = obj.objectForKey("Name") as! String
                pin.subtitle = obj.objectForKey("StartTime")!.description
                self.mapView.addAnnotation(pin)
                self.events.append(obj)
            }

        })
    }

}

