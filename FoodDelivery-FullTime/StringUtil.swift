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
}
