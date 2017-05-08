//
//  GlobalVariable.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/15/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//
import GoogleMaps

class GlobalVariables {
    
    // These are the properties you can store in your singleton
    var currentLocation :CLLocationCoordinate2D?
    var curOrder = Order()
    var curBikeStation = BikeStation()
    var recommendBikeStation = BikeStation()
    var fullStatusId = 0
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class public var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
