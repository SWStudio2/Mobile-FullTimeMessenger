//
//  HeaderView.swift
//  LabelTeste
//
//  Created by Rondinelli Morais on 11/09/15.
//  Copyright (c) 2015 Rondinelli Morais. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: NSObjectProtocol {
    func headerViewOpen(_ section:Int)
    func headerViewClose(_ section:Int)
}

class HeaderView: UIView {
    
    var delegate:HeaderViewDelegate?
    var section:Int?
    var tableView:UIExpandableTableView?
    var merImg = UIImageView()
    var merNameLbl = UILabel()
    var merAddress = UITextView()
    var statusView = UIView()
    
    required init(tableView:UIExpandableTableView, section:Int){
        print("Header")
        var height = tableView.delegate?.tableView!(tableView, heightForHeaderInSection: section)
        var frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: height!)
        
        super.init(frame: frame)
        
        self.tableView = tableView
        self.delegate = tableView
        self.section = section
        //self.merNameLbl.text = "Hi"
        merImg = UIImageView.init(frame: CGRect(x: 5, y: 5, width: self.frame.height - 10, height: self.frame.height - 10))
        merImg.image = UIImage(named: "image-not-found")
        merImg.contentMode = .scaleAspectFit
        //merImg.frame = CGRect(x: 8, y: 8, width: 65, height: 65)
        self.addSubview(merImg)
        merNameLbl.frame = CGRect(x: 88, y: 8, width: 200, height: 20)
        merNameLbl.font = UIFont.boldSystemFont(ofSize: 18)
        self.addSubview(merNameLbl)
        merAddress = UITextView.init(frame: CGRect(x: 83, y: 28, width: self.frame.width - merImg.frame.width - 50, height: self.frame.height - 30))
        merAddress.isEditable = false
        merAddress.isSelectable = false
        merAddress.textColor = UIColor.gray
        self.addSubview(merAddress)
        
        statusView = UIView.init(frame: CGRect(x: 0, y: 0, width: 3, height: self.frame.height))
        self.addSubview(statusView)
        
        //headerView.addSubview(imageView)
        var line = UIView.init(frame: CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 1.0))
        line.backgroundColor = UIColor.init(red: 230/256, green: 230/256, blue: 230/256, alpha: 1)
        self.addSubview(line)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var toggleButton = UIButton()
        toggleButton.addTarget(self, action: "toggle:", for: UIControlEvents.touchUpInside)
        toggleButton.backgroundColor = UIColor.clear
        toggleButton.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(toggleButton)
    }
    
    func toggle(_ sender:AnyObject){
        
        if self.tableView!.sectionOpen != section! {
            self.delegate?.headerViewOpen(section!)
        } else if self.tableView!.sectionOpen != NSNotFound {
            self.delegate?.headerViewClose(self.tableView!.sectionOpen)
        }
    }
}

