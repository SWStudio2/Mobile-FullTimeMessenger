//
//  NotiDetailViewController.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 5/1/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import Alamofire

class NotiDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var detailTxt : UITextView!
    
    var noti = Noti()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "แจ้งเตือนออร์เดอร์รหัส \(noti.noti_order_id)"
        self.dateLbl.text = noti.noti_created_date
        self.detailTxt.text = noti.noti_message_detail
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptOrder(){
        
        let defaults = UserDefaults.standard
        let fullId = defaults.value(forKey: FULLID_KEY) as! String
        let  value1  = ["full_id" : Int.init(fullId) ,
                        "noti_id" : noti.noti_id,
                        "isAccept" : Y_FLAG] as [String : Any]
        
        Alamofire.request(BASEURL+ACCEPTASSIGN,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
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
