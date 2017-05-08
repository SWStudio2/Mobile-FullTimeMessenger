//
//  StringUtil.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/16/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation

extension String {
    func getCurrentDateFormat(date : Date) -> String{
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        dateFormatter.locale = NSLocale.current
        
        return dateFormatter.string(from: date)
    }

    func convertDateTime() -> String {
        let comps = NSDateComponents()
        
        comps.hour = 7
        var orderEstimatedDateTime = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale.current
        let cal = NSCalendar.current
        var date = dateFormatter.date(from: self)
        let r = cal.date(byAdding: comps as DateComponents, to: date!)
        let str = dateFormatter.string(from: r!)
        orderEstimatedDateTime = str
        
        return orderEstimatedDateTime
    }
    func convertTime() -> String {
        let comps = NSDateComponents()
        
        comps.hour = 7
        var orderEstimatedDateTime = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale.current
        let cal = NSCalendar.current
        var date = dateFormatter.date(from: self)
        let r = cal.date(byAdding: comps as DateComponents, to: date!)
        let str = dateFormatter.string(from: r!)
        orderEstimatedDateTime = str
        
        let start = orderEstimatedDateTime.index(orderEstimatedDateTime.startIndex, offsetBy: 11)
        let end = orderEstimatedDateTime.index(orderEstimatedDateTime.endIndex, offsetBy: -3)
        let range = start..<end
        
        orderEstimatedDateTime = orderEstimatedDateTime.substring(with: range)
        return orderEstimatedDateTime
    }
    
}
