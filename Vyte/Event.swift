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
    var host: PFUser!
    var name: String!
    var description: String!
    var address: String!
    var location: PFGeoPoint!
    var start_time: NSDate!
    var end_time: NSDate!
    var timezone: Int!
    var rsvp_status: String!
    var objectId : AnyObject
    
    init(host: PFUser!, name: String!, address: String!, location: PFGeoPoint!, start_time: NSDate!, end_time: NSDate!, timezone: Int!, rsvp_status: String!) {
        self.host = host
        self.name = name
        self.location = location
        self.start_time = start_time
        self.end_time = end_time
        self.timezone = timezone
        self.rsvp_status = rsvp_status
        self.objectId = 0
    }
    
    init(host: PFUser!, name: String!, description: String!, address: String!, location: PFGeoPoint!, start_time: NSDate!) {
        self.host = host
        self.name = name
        self.description = description
        self.address = address
        self.location = location
        self.start_time = start_time
        self.objectId = 0
    }
    
    init(name: String!, description: String!, address: String!, location: PFGeoPoint!, start_time: NSDate!) {
        self.name = name
        self.description = description
        self.address = address
        self.location = location
        self.start_time = start_time
        self.objectId = 0
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
        self.objectId = event.objectId!
        //event.saveEventually(nil)
    }
    
    func getAttendingUsers() -> [PFUser] {
        let q = PFQuery(className: "User").whereKey("AttendingEvents", containsAllObjectsInArray: [self.objectId])
        return q.findObjects() as! [PFUser]

    }
    
}

