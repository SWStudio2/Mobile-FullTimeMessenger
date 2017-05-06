//
//  OrderPerMerchantViewController.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/16/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import Alamofire

class OrderPerMerchantViewController: UIViewController {
    @IBOutlet weak var merNameLbl : UILabel!
    @IBOutlet weak var merAddressTxt : UITextView!
    @IBOutlet weak var merImg : UIImageView!
    @IBOutlet weak var confirmTxt : UITextField!
    @IBOutlet weak var confirmBtn : UIButton!
    @IBOutlet weak var orderTbv : UITableView!
    @IBOutlet weak var sumPriceLbl : UILabel!
    @IBOutlet weak var confirmView : UIView!
    
    var order : SeqOrder? = nil
    var deliveryRate:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "รายละเอียดออร์เดอร์"
        // Do any additional setup after loading the view.
        
        self.orderTbv.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
    }
    
    func setupView(){
        self.merNameLbl.text = order?.merchant.merName
        self.merAddressTxt.text = order?.merchant.merAddress
        self.sumPriceLbl.text = String.init(format:"%.2f",calPrice())
        if order?.seqor_receive_status_id == MERCHANT_RECEIVED_STATUS {
            self.confirmView.isHidden = true
        }
        
    }
    
    func calPrice() -> Double{
        if order?.merchant.merRegisFlag == 0 {
        var sum = 0.0
        let deliveryPrice = Double.init(deliveryRate) * Double.init((order?.seqor_mer_distance)!)
            for detail in (order?.orderDetails)! {
                if detail.order_detail_status == Y_FLAG {
                    var optionPrice = 0.0
                    for opt in (detail.options) {
                        optionPrice = optionPrice + opt.option_price
                    }
                    sum =  sum + (detail.menu.menu_price + optionPrice) * Double.init(detail.order_detail_amount)
                    print("sum \(sum)")
                }
            }
            return sum
        }else{
            return 0.0
        }
      //  sum += deliveryPrice
      //  print("deliveryPrice \(deliveryPrice)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clickedConfirm(){
        // call web service to verify confirm code
        let defaults = UserDefaults.standard
        
        let value = ["mer_id": Int64.init((order?.merchant.merID)!),
                     "order_id": Int64.init(GlobalVariables.sharedManager.curOrder.order_id),
                     "full_id" : Int64.init(defaults.value(forKey: FULLID_KEY) as! String),
                     "seqor_confirm_code" : self.confirmTxt.text] as [String : Any]
        
        
        Alamofire.request(BASEURL+VERIFYCONFIRM_MER,method: .post, parameters: value, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in

                print("Response \(response)")
                if let jsonResult = response.result.value {
                    do {
                        if ((jsonResult as AnyObject).object(forKey: DATA_KEY) != nil) {
                            let dataDict = (jsonResult as AnyObject).object(forKey: DATA_KEY) as! NSDictionary
                            let isPass = dataDict.object(forKey: ISPASS_KEY) as! String
                            if isPass == Y_FLAG {
                                self.validationConfirmCodePass()
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
    
    func validationConfirmCodePass(){
        let alert = UIAlertController(title: "ตรวจสอบ Cornfirm Code", message: "รับอาหารจากร้านค้า \((order?.merchant.merName)!) เรียบร้อยแล้ว" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.default, handler: { action in
            self.order?.seqor_receive_status_id = MERCHANT_RECEIVED_STATUS
            var completeCnt = 0
            for seq in GlobalVariables.sharedManager.curOrder.seqOrders {
                if seq.seqor_receive_status_id == MERCHANT_RECEIVED_STATUS {
                    completeCnt += 1
                }
            }
            if completeCnt == GlobalVariables.sharedManager.curOrder.seqOrders.count {
                GlobalVariables.sharedManager.curOrder.order_status_id = ORDER_DELIVERING_STATUS
            }
            
            
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
    
    @IBAction func callMer(){
        if let phoneCallURL = URL(string: "tel://\((order?.merchant.merContactNumber)!)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }

}

extension OrderPerMerchantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "OrderPerMerTableViewCell", for: indexPath) as! OrderPerMerTableViewCell
        let orderDetail = (order?.orderDetails[indexPath.row])!
        cell.menuNameLbl.text = orderDetail.menu.menu_name
        cell.menuNumLbl.text = String.init(format : "%d",(orderDetail.order_detail_amount))
        var optionStr = ""
        var optionPrice = 0.0
        var i = 0
        for opt in orderDetail.options {
            if i > 0 {
                optionStr = optionStr + ", "
            }
            optionStr = optionStr + opt.option_neme
            optionPrice = optionPrice + opt.option_price
            i += 1
        }
        if orderDetail.order_detail_status == Y_FLAG {
            cell.menuPriceLbl.text = String.init(format: "%.2f", orderDetail.menu.menu_price + optionPrice)
        }else{
            cell.menuPriceLbl.text = "0.00"
            cell.menuNameLbl.textColor = UIColor.lightGray
            cell.menuPriceLbl.textColor = UIColor.lightGray
            cell.menuNumLbl.textColor = UIColor.lightGray
            
        }
        cell.menuOptionLbl.text = optionStr
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (order?.orderDetails.count)!
    }
}
