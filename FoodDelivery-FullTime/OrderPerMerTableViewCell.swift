//
//  OrderPerMerTableViewCell.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/16/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit

class OrderPerMerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuNameLbl:UILabel!
    @IBOutlet weak var menuNumLbl:UILabel!
    @IBOutlet weak var menuPriceLbl:UILabel!
    @IBOutlet weak var menuOptionLbl:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
