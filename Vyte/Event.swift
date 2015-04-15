//
//  Event.swift
//  Vyte
//
//  Created by Matthew Miklasevich on 4/6/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import Foundation
import MapKit

enum RSVP_STATUS: String {
    case attending = "attending", maybe = "maybe", declined = "declined"
    
    static let all_values = [attending, maybe, declined]
}

class Event {
    var name: String!
    var description: String!
    var address: String!
    var location: PFGeoPoint!
    var start_time: NSDate!
    var end_time: NSDate!
    var timezone: Int!
    var rsvp_status: String!
    
    var host: PFUser!
    
    init(name: String!, address: String!, location: PFGeoPoint!, start_time: NSDate!, end_time: NSDate!, timezone: Int!, rsvp_status: String!) {
        self.name = name
        self.location = location
        self.start_time = start_time
        self.end_time = end_time
        self.timezone = timezone
        self.rsvp_status = rsvp_status
    }
    
    init(host: PFUser!, name: String!, description: String!, address: String!, location: PFGeoPoint!, start_time: NSDate!) {
        self.host = host
        self.name = name
        self.description = description
        self.address = address
        self.location = location
        self.start_time = start_time
        
        self.recordInfo()
    }
    
    func recordInfo() {
        var event = PFObject(className:"Event")
        event["Host"] = self.host.username
        event["Name"] = self.name
        event["Description"] = self.description
        event["Address"] = self.address
        event["Location"] = self.location
        event["StartTime"] = self.start_time
        event.saveInBackgroundWithBlock(nil)
        event.saveEventually(nil)
    }
    
}
/*
let formatter = NSDateFormatter()
formatter.dateStyle = NSDateFormatterStyle.ShortStyle
formatter.timeStyle = NSDateFormatterStyle.ShortStyle

let dateA = formatter.dateFromString("4/7/2015 7:00 PM")
let locationA = CLLocationCoordinate2D(42.359184, -71.093544)
let eventA = Event("eventA",locationA,dateA)*/
