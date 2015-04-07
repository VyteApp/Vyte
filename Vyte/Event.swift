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
    var start_time: NSDate!
    var end_time: NSDate!
    var timezone: Int!
    var rsvp_status: String!
    
    init(name: String!, start_time: NSDate!, end_time: NSDate!, timezone: Int!, rsvp_status: String!) {
        self.name = name
        self.start_time = start_time
        self.end_time = end_time
        self.timezone = timezone
        self.rsvp_status = rsvp_status
    }
    
}