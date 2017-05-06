//
//  Order.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/15/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation

class Order : NSObject {
    var order_address = ""
    var order_address_latitude = ""
    var order_address_longtitude = ""
    var order_created_datetime = ""
    var order_delivery_price = 0
    var order_delivery_rate = 0
    var order_food_price = 0
    var order_id = 0
    var order_total_price = 0
    var seqOrders:[SeqOrder] = []
    var order_estimate_datetime = ""
    var order_status = ""
    var order_status_id = 0
    var customer = Customer()
    
    override init (){
    }
    
    init (json:NSDictionary){
        self.order_address = json["orderAddress"] as! String
        self.order_address_latitude = json["orderAddressLatitude"] as! String
        self.order_address_longtitude = json["orderAddressLongtitude"] as! String
        self.order_created_datetime = json["order_created_datetime"] as! String
        self.order_delivery_price = json["orderDeliveryPrice"] as! Int
        self.order_delivery_rate = json["orderDeliveryRate"] as! Int
        self.order_food_price = json["orderFoodPrice"] as! Int
        self.order_id = json["orderId"] as! Int
        self.order_total_price = json["orderTotalPrice"] as! Int
        self.order_estimate_datetime = json["order_estimate_datetime"] as! String
        self.order_status = (json["statusConfig"] as! NSDictionary)["status_name"] as! String
        self.order_status_id = json["orderStatus"] as! Int
        let seqOrderList = json["sequenceOrders"] as! NSArray
        
        for seq in seqOrderList {
            var seqOrder = SeqOrder(json: seq as! NSDictionary)
            seqOrders.append(seqOrder)
        }
        customer = Customer(json: json["customer"] as! NSDictionary)

    }
}
