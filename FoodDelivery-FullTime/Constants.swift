//
//  Constants.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/11/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import Foundation
import UIKit

//class CONSTANTS {
//Color
let GRAY:UIColor = UIColor(red: 120/255, green: 144/255, blue: 156/255, alpha: 1)
let GREEN:UIColor = UIColor(red: 135/255, green: 197/255, blue: 80/255, alpha: 1)
let ORANGE:UIColor = UIColor(red: 255/255, green: 112/255, blue: 67/255, alpha: 1)
let GOOGLEMAP_KEY = "AIzaSyDSXxEiXTHr-7UG1uIa4Za79fZhtI3Y1sI"
//let GOOGLEMAP_KEY = "AIzaSyCQQmDCGFkJ4bR3sslC1f9OXFIcXNveStU"
let header = ["Accept" : "application/json" , "Content-Type" : "application/json"]

//  Segue
let LOGINSUCCESS_SEGUE = "loginSuccessSegue"
//let BASEURL = "https://fooddelivery-test.eu-gb.mybluemix.net/service/"
//let BASEURL = "http://bdb240eb.ngrok.io/fooddelivery-0.3/service/"
//let BASEURL = "http://127.0.0.1:8081/fooddelivery-0.4/service/"
let BASEURL = "http://127.0.0.1:8082/fooddelivery-0.8/service/"
let BASETESTURL = "https://fooddelivery.eu-gb.mybluemix.net/service/"
let DISTANCEMATRIX = "getdistancematrix"
let AUTH = "fulltime/auth"
let UPDATELOC = "fulltime/updateloc"
let GETASSIGNMENT = "fulltime/"
let GETNOTILIST = "orders/noti"
let READNOTI = "orders/noti/accept"
let ACCEPTASSIGN = "fulltime/accept"
let BACKTOSTATION = "fulltime/backtostation"
let VERIFYCONFIRM_MER = "orders/confirmcode/merchant"
let VERIFYCONFIRM_CUS = "orders/confirmcode/customer"



let DATA_KEY = "data"
let ORDER_KEY = "order"
let STATION_KEY = "bikeStation"
let SEQORDER_KEY = "seqOrder"
let ISMER_KEY = "isMer"
let CUS_KEY = "full"
let FULLID_KEY = "full_id"
let FULLNAME_KEY = "full_name"
let FULLCONTACT_KEY = "full_contact_number"
let FULLEMAIL_KEY = "full_email"
let FULLSTATUS_KEY = "full_status"
let ISPASS_KEY = "isPass"
let ORDERID_KEY = "order_id"
let SEQRECEIVE_STATUS_KEY = "seqor_receive_status"
let BIKESTATION_KEY = "bikeStation"

let Y_FLAG = "Y"
let N_FLAG = "N"


let LOCSTEP = 180

let MENUNAME = ["กลับสู่หน้าหลัก","ออกจากระบบ"]

let MERCHANT = "ร้านค้า"
let CUSTOMER = "ลูกค้า"
let STATION = "จุดจอด"

let NOTI_TYPE_MESS = "Messenger"

let ORDER_WAITING_RESPONSE_STATUS 	= 1;//"รอรับออร์เดอร์";
let ORDER_COOKING_STATUS 			= 2; //กำลังทำอาหาร
let ORDER_DELIVERING_STATUS 		= 3; //กำลังส่งอาหาร
let ORDER_RECEIVED_STATUS 			= 4; //ส่งอาหารแล้ว

let MESSENGER_WAITING_CONFIRM_STATUS = 5; //รอการคอนเฟิร์ม
let MESSENGER_RECEIVING_STATUS 		= 6; //กำลังไปรับอาหาร
let MESSENGER_IGNORE_STATUS 		= 7; //ไม่ทำ
let MESSENGER_DELIVERING_STATUS		= 8; //กำลังไปส่งอาหาร
let MESSENGER_DELIVERIED_STATUS		= 9; //ส่งอาหารแล้ว
let MESSENGER_STATION_STATUS		= 10; //อยู่ที่จุดจอด

let MERCHANT_WAITING_CONFIRM_STATUS	= 11; // รอการคอนเฟิร๋ม
let MERCHANT_CONFIRMED_STATUS		= 12; //คอนเฟิร์มแล้ว
let MERCHANT_IGNORE_STATUS			= 13; //ไม่ทำ
let MERCHANT_RECEIVED_STATUS		= 14; //รับอาหารแล้ว

//}

