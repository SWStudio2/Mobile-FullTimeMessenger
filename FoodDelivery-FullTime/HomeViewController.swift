 //
//  HomeViewController.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/14/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class HomeViewController: BaseViewController, GMSMapViewDelegate {


    @IBOutlet weak var tableView:UIExpandableTableView!
    @IBOutlet weak var cusNameLbl : UILabel!
    @IBOutlet weak var cusAddressLTxt : UITextView!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var orderEstimateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var telBtn:UIButton!
    @IBOutlet weak var arrivalBtn:UIButton!
    var merTotalPrice = 0.0
    var merDeliveryPrice = 0.0
    let locationManager = CLLocationManager()
    var i = 0
    var order:Order? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.addSlideMenuButton()
        self.addMapMenuButton()
        self.navigationItem.setHidesBackButton(true, animated: false)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.tableView.isHidden = true
        self.orderNoLbl.isHidden = true
        self.telBtn.isHidden = true
        self.orderEstimateLbl.isHidden = true
        self.timeLbl.isHidden = true
        self.telBtn.isHidden = true
        self.arrivalBtn.isHidden = true
        self.cusAddressLTxt.isHidden = true
        self.cusNameLbl.isHidden = true
        //order = GlobalVariables.sharedManager.curOrder
        self.getMapList()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getMapList()
    }

    
    func getMapList(){
        let defaults = UserDefaults.standard
        let fullId = defaults.value(forKey: FULLID_KEY) as! Int
        

        let URL = BASEURL+GETASSIGNMENT+"\(fullId)"
        Alamofire.request(URL).responseJSON {
                response in
                print("Response \(response)")
                if let jsonResult = response.result.value {
                    do {
                        if ((jsonResult as AnyObject).object(forKey: DATA_KEY) != nil) {
                            let dataDict = (jsonResult as AnyObject).object(forKey: DATA_KEY) as! NSDictionary
                            let orderDict = dataDict.object(forKey: ORDER_KEY) as! NSDictionary
                            let stationDict = dataDict.object(forKey: STATION_KEY) as! NSDictionary
                            self.order = Order(json: orderDict)
                            GlobalVariables.sharedManager.curOrder = self.order!
                            self.order?.seqOrders = (self.order?.seqOrders.sorted { $0.seqor_sort < $1.seqor_sort })!
                            GlobalVariables.sharedManager.curBikeStation = BikeStation(json: stationDict)
                            self.prepareView()
                            
                        }
                    } catch let error {
                        print("error")
                    }
            }
        }
        
    }
    
    func prepareView(){
        let defaults = UserDefaults.standard
        if GlobalVariables.sharedManager.fullStatusId == MESSENGER_DELIVERIED_STATUS {
            self.initValueForBackToStation()
            
        } else if GlobalVariables.sharedManager.fullStatusId == MESSENGER_STATION_STATUS {
            self.initValueAvailable()
        }else{
            self.initValue()
            
        }
        //self.tableView.reloadData()
    }
    
    func initValue(){
        self.tableView.isHidden = false
        self.orderNoLbl.isHidden = false
        self.telBtn.isHidden = false
        self.orderEstimateLbl.isHidden = false
        self.timeLbl.isHidden = false
        self.telBtn.isHidden = false
        self.arrivalBtn.isHidden = true
        self.cusAddressLTxt.isHidden = false
        self.cusNameLbl.isHidden = false
        self.tableView.reloadData()
        self.cusNameLbl.text = order?.customer.cus_name
        self.cusAddressLTxt.text = order?.order_address
        self.orderNoLbl.text = "รายละเอียดออร์เดอร์ เลขที่ \((order?.order_id)!)"
        self.orderEstimateLbl.text = self.order?.order_estimate_datetime.convertTime()
    }
    
    func initValueForBackToStation(){
        self.tableView.isHidden = true
        self.orderNoLbl.isHidden = true
        self.orderEstimateLbl.isHidden = true
        self.telBtn.isHidden = true
        self.timeLbl.isHidden = false
        self.telBtn.isHidden = true
        self.arrivalBtn.isHidden = false
        self.cusAddressLTxt.isHidden = true
        self.cusNameLbl.isHidden = false
        let defaults = UserDefaults.standard
        let name = defaults.value(forKey: FULLNAME_KEY) as! String
        self.cusNameLbl.text = "สวัสดีคุณ \(name)"
        self.timeLbl.text = "กรุณากลับจุดจอด \(GlobalVariables.sharedManager.curBikeStation.bike_station_name)"
        
    }
    
    func initValueAvailable(){
        
        self.tableView.isHidden = true
        self.orderNoLbl.isHidden = true
        self.orderEstimateLbl.isHidden = true
        self.telBtn.isHidden = true
        self.timeLbl.isHidden = false
        self.telBtn.isHidden = true
        self.arrivalBtn.isHidden = true
        self.cusAddressLTxt.isHidden = true
        self.cusNameLbl.isHidden = false
        let defaults = UserDefaults.standard
        let name = defaults.value(forKey: FULLNAME_KEY) as! String
        self.cusNameLbl.text = "สวัสดีคุณ \(name)"
        self.timeLbl.text = "คุณอยู่ที่จุดจอด \(GlobalVariables.sharedManager.curBikeStation.bike_station_name)"
        
    }
    
    @IBAction func callCustomer(){
        if let phoneCallURL = URL(string: "tel://\((order?.customer.cus_name)!)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func arrivedStation(){
        let defaults = UserDefaults.standard
        let fullId = defaults.value(forKey: FULLID_KEY) as! Int
        let alert = UIAlertController(title: "รายงานจุดจอด", message: "คุณถึงจุดจอด \(GlobalVariables.sharedManager.curBikeStation.bike_station_name) เรียบร้อยแล้ว?" , preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "ยืนยัน", style: UIAlertActionStyle.default, handler: { action in
            Alamofire.request(BASEURL+BACKTOSTATION+"\(fullId)")
                .responseJSON { response in
                    print("Response \(response)")
                    if let jsonResult = response.result.value {
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                    }
            }
            
            
        }))
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
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
                
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first  {
            
            GlobalVariables.sharedManager.currentLocation = location.coordinate
            /*
            i += 1
            
            if i%LOCSTEP == 0 {
                print("lat : \(location.coordinate.latitude) long : \(location.coordinate.longitude)")
                i = 0
                let defaults = UserDefaults.standard
                
                let  value1  = ["full_id" : Int(defaults.value(forKey: FULLID_KEY) as! String),
                                "full_lastest_lattitude" : "\(location.coordinate.latitude)",
                                "full_lastest_longtitude": "\(location.coordinate.longitude)"] as [String : Any]
             
                Alamofire.request(BASEURL+UPDATELOC,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
                    .responseJSON { response in
                        print("Response \(response)")
                        
                        //to get status code
                        
                        if let status = response.response?.statusCode {
                            switch(status){
                            case 200:
                                
                                print("example success")
                                //to get JSON return value
                                if let result = response.result.value {
                                }
                            
                            default:
                            print("error with response status: \(status)")
                        }
                    }
                }
                
                
            }*/
        }
    }
}



extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if order != nil {
            return (order?.seqOrders.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((order?.seqOrders.count)! > 0) {
            if (self.tableView.sectionOpen != NSNotFound && section == self.tableView.sectionOpen) {
                return  (order?.seqOrders[section].orderDetails.count)! + 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.row \(indexPath.row)")
        
        
        if indexPath.row == 0{
            merDeliveryPrice = 0.0
            merTotalPrice = 0.0
            var cell = tableView.dequeueReusableCell(withIdentifier: "titleOrderTableViewCell", for: indexPath) as! TitleOrderTableViewCell
            //cell.textLabel?.text = "section \(indexPath.section) row \(indexPath.row)"
            //cell.textLabel?.backgroundColor = UIColor.clear
            return cell
            
        }else if indexPath.row == ((order?.seqOrders[indexPath.section].orderDetails.count)! + 1) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "summaryOrderTableViewCell", for: indexPath) as! SummaryOrderTableViewCell
            let isRegis = order?.seqOrders[indexPath.section].merchant.merRegisFlag
            if isRegis == 0 {
                cell.sumPrice.text = String(format: "%.2f", self.merTotalPrice) as String
                
            }else{
                cell.sumPrice.text = "0.00"
            }
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! BasketTableViewCell
            let orderDetail = order?.seqOrders[indexPath.section].orderDetails[indexPath.row - 1]
            
            cell.nameLbl.text = orderDetail?.menu.menu_name
            cell.numLbl.text =  "\((orderDetail?.order_detail_amount)!)"
            var optionStr = ""
            var optionPrice = 0.0
            var i = 0
            for opt in (orderDetail?.options)! {
                if i > 0 {
                    optionStr = optionStr + ", "
                }
                optionStr = optionStr + opt.option_neme
                optionPrice = optionPrice + opt.option_price
                i += 1
            }
            cell.optionLbl.text = optionStr
            if orderDetail?.order_detail_status == Y_FLAG {
                cell.priceLbl.text = String.init(format: "%.2f", ((orderDetail?.menu.menu_price)! + optionPrice))
                self.merTotalPrice = self.merTotalPrice + Double.init(cell.priceLbl.text!)!
            }else{
                cell.priceLbl.text = "0.00"
                cell.nameLbl.textColor = UIColor.lightGray
                cell.priceLbl.textColor = UIColor.lightGray
                cell.numLbl.textColor = UIColor.lightGray
            }
            return cell
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = HeaderView(tableView: self.tableView, section: section)
        headerView.backgroundColor = UIColor.white
        let header = order?.seqOrders[section].merchant.merName
        headerView.merNameLbl.text = header
        headerView.merAddress.text = order?.seqOrders[section].merchant.merAddress
        if order?.seqOrders[section].seqor_receive_status_id == MERCHANT_RECEIVED_STATUS {
           headerView.statusView.backgroundColor = GREEN
        }else{
            headerView.statusView.backgroundColor = ORANGE
        }
        
       
        let btn = UIButton.init(frame: CGRect(x: headerView.frame.width - 50 , y: 0, width: 50, height: headerView.frame.height))
       
        btn.setImage(UIImage.init(named: "more_than_filled"), for: UIControlState.normal)
        btn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        btn.tag = section
        btn.addTarget(self, action: #selector(HomeViewController.clickedDetailMer(_:)), for: UIControlEvents.touchUpInside)
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height))
        view.addSubview(headerView)
        view.addSubview(btn)
        
        return view
    }
    
    func clickedDetailMer(_ sender : UIButton){
        let section = sender.tag
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderPerMerchantViewController") as? OrderPerMerchantViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
                viewController.deliveryRate = (order?.order_delivery_rate)!
                viewController.order = (order?.seqOrders[section])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let orderDetails = order?.seqOrders[indexPath.section].orderDetails
        if indexPath.row == 0{
            return 40
            
        }else if indexPath.row == ((orderDetails?.count)! + 1) {
            return 50
        }
        return 60
        
    }
    
    
}

