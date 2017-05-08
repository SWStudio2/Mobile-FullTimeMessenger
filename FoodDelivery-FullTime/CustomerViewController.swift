//
//  CustomerViewController.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/16/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//


import UIKit
import GoogleMaps
import Alamofire

class CustomerViewController: UIViewController {
    @IBOutlet weak var cusNameLbl : UILabel!
    @IBOutlet weak var cusArressTxt : UITextView!
    @IBOutlet weak var foodPriceLbl : UILabel!
    @IBOutlet weak var deliveryPriceLbl : UILabel!
    @IBOutlet weak var sumPriceLbl : UILabel!
    @IBOutlet weak var confirmTxt : UITextField!
    @IBOutlet weak var mapView:GMSMapView!
    @IBOutlet weak var confirmView:UIView!
    
    var order : Order? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "ออร์เดอร์คุณ \((order?.customer.cus_name)!)"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
        self.setupMap()
        if order?.order_status_id != ORDER_DELIVERING_STATUS {
            self.confirmView.isHidden = true
        }else{
            self.confirmView.isHidden = false
        }
    }
    
    func setupView(){
        print("order?.order_food_price \(order?.order_food_price)")
        self.cusNameLbl.text = order?.customer.cus_name
        self.cusArressTxt.text = order?.order_address
        self.foodPriceLbl.text = String.init(format : "%.2f", Double.init((order?.order_food_price)!))
        self.deliveryPriceLbl.text = String.init(format : "%.2f", Double.init((order?.order_delivery_price)!))
        self.sumPriceLbl.text = String.init(format : "%.2f", Double.init((order?.order_total_price)!))
    }
    
    func setupMap(){
        let marker = GMSMarker()
        let lat = Double.init((order?.order_address_latitude)!)!
        let long = Double.init((order?.order_address_longtitude)!)!
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.map = mapView
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: "location_green_filled")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        marker.iconView = imageView
        self.mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D.init(latitude: lat, longitude:  long), zoom: 15, bearing: 0, viewingAngle: 0)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedCall(){
        if let phoneCallURL = URL(string: "tel://\((order?.customer.cus_contact_number)!)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func clickedConfirm(){
        // call web service to verify confirm code
        let defaults = UserDefaults.standard
        
        let order = GlobalVariables.sharedManager.curOrder
        var merList:[Int] = []
        for seq in order.seqOrders {
            merList.append(seq.merchant.merID)
        }
        
        let value = ["mer_id": merList,
                     "order_id": Int64.init(GlobalVariables.sharedManager.curOrder.order_id),
                     "full_id" : defaults.value(forKey: FULLID_KEY) as! Int,
                     "seqor_confirm_code" : (self.confirmTxt!.text)!] as [String : Any]
        
        print("value \(value)")
        Alamofire.request(BASEURL+VERIFYCONFIRM_CUS,method: .post, parameters: value, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                
                print("Response \(response)")
                if let jsonResult = response.result.value {
                    do {
                        if ((jsonResult as AnyObject).object(forKey: DATA_KEY) != nil) {
                            let dataDict = (jsonResult as AnyObject).object(forKey: DATA_KEY) as! NSDictionary
                            let isPass = dataDict.object(forKey: ISPASS_KEY) as! String
                            if isPass == Y_FLAG {
                                let recommendStationDict = dataDict.object(forKey: BIKESTATION_KEY) as! NSDictionary
                                self.validationConfirmCodePass(recommendStationDict: recommendStationDict)
                            }else{
                                self.validationConfirmCodeFail()
                            }
                        }
                    } catch let error {
                        print("error")
                    }
                }
        }

    }
    
    func validationConfirmCodePass(recommendStationDict:NSDictionary){
        let recommendStation = BikeStation.init(json: recommendStationDict)
        GlobalVariables.sharedManager.recommendBikeStation = recommendStation
        GlobalVariables.sharedManager.curBikeStation = recommendStation
        let alert = UIAlertController(title: "ตรวจสอบ Confirm Code", message: "ส่งอาหารถึงลูกค้า คุณ\((order?.customer.cus_name)!) เรียบร้อยแล้ว \r\n กรุณาเดินทางกลับจุดจอด \(recommendStation.bike_station_name)" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default, handler: { action in
            self.order?.order_status_id = ORDER_DELIVERING_STATUS
            GlobalVariables.sharedManager.fullStatusId = MESSENGER_DELIVERIED_STATUS
            if let navController = self.navigationController {
                
                navController.popViewController(animated: true)
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func validationConfirmCodeFail(){
        let alert = UIAlertController(title: "ตรวจสอบ Cornfirm Code", message: "Confirm Code ไม่ถูกต้อง" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
