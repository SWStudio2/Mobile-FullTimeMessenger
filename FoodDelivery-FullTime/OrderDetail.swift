//
//  OrderDetail.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/15/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation

class OrderDetail : NSObject {
    var order_detail_amount = 0
    var order_detail_id = 0
    var order_detail_status = ""
    var order_remark = ""
    var menu = Menu()
    var options:[Option] = []
    override init(){
        
    }
    init(json:NSDictionary){
        self.order_detail_amount = json["orderDetailAmount"] as! Int
        self.order_detail_id = json["orderDetailId"] as! Int
        self.order_detail_status = json["orderDetailStatus"] as! String
        self.order_remark = json["orderRemark"] as! String
        self.menu = Menu(json:json["menu"] as! NSDictionary)
        if json["ordersDetailOptions"] != nil {
            let optionList = json["ordersDetailOptions"] as! NSArray
            
            for option in optionList {
                var opt = Option(json: option as! NSDictionary)
                options.append(opt)
            }
        }
    }
}
