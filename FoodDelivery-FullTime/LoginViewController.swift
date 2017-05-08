//
//  LoginViewController.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/11/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    @IBOutlet weak var txtUsername : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var btnLogin : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnLogin.setButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        txtUsername.text = "full21@test.com"
        txtPassword.text = "pass"
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLoginClicked(){
        
        let name = txtUsername.text!
        let pass =  txtPassword.text!
        let  value1  = ["fullEmail" : name ,
                        "fullPassword" : pass]
        
        Alamofire.request(BASEURL+AUTH,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print("Response \(response)")
                
                //to get status code
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        print("example success")
                        //to get JSON return value
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            let fullId = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: FULLID_KEY) as! Int
                            //let fullContact = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: FULLCONTACT_KEY)
                            let fullName = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: FULLNAME_KEY)
                            let fullStatusId = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: FULLSTATUS_KEY) as! Int
                            let defaults = UserDefaults.standard
                            defaults.set(fullId,forKey: FULLID_KEY)
                            defaults.set(fullStatusId,forKey: FULLSTATUS_KEY)
                            defaults.set(fullName,forKey: FULLNAME_KEY)
                            let stationDict = (JSON.object(forKey: DATA_KEY) as! NSDictionary).object(forKey: STATION_KEY) as! NSDictionary
                            GlobalVariables.sharedManager.fullStatusId = fullStatusId
                            GlobalVariables.sharedManager.curBikeStation = BikeStation(json: stationDict)
                            self.performSegue(withIdentifier: LOGINSUCCESS_SEGUE, sender: JSON)
                            print("Success")
                    }
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
        }
        
    }
    

}
