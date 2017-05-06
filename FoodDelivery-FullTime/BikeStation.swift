//
//  BikeStation.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/22/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation

class BikeStation : NSObject {
    var bike_station_id = 0
    var bike_station_latitude = ""
    var bike_station_longitude = ""
    var bike_station_name = ""
    
    override init(){
        
    }
    
    init(json:NSDictionary){
        self.bike_station_id = json["bikeStationId"] as! Int
        self.bike_station_latitude = json["bikeStationLatitude"] as! String
        self.bike_station_longitude = json["bikeStationLongitude"] as! String
        self.bike_station_name = json["bikeStationName"] as! String
        
    }
}
