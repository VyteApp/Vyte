//
//  FirstViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 3/24/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController, MKMapViewDelegate, FBRequestConnectionDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
        showNearbyEvents()
    }

    //TODO: Have this function called periodically?
    func showNearbyEvents() {
        let currentLocation = mapView.userLocation.coordinate
        //radius = 50 m
        //results limit = 25
        //search text = nil
        FBRequestConnection.startForPlacesSearchAtCoordinate(currentLocation,radiusInMeters: 50,resultsLimit: 25,searchText: nil,{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) in
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

