//
//  StationViewController.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/23/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class StationViewController: UIViewController {
    
    @IBOutlet weak var stationNameLbl : UILabel!
    @IBOutlet weak var mapView:GMSMapView!
    @IBOutlet weak var backBtn:UIButton!
    var station = BikeStation()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        self.stationNameLbl.text = station.bike_station_name
        self.title = station.bike_station_name
        self.backBtn.isHidden = true
        if GlobalVariables.sharedManager.fullStatusId == MESSENGER_DELIVERIED_STATUS {
            self.backBtn.isHidden = false
        }
    
    }
    
    func setupMap(){
        let marker = GMSMarker()
        let lat = Double.init((station.bike_station_latitude))!
        let long = Double.init((station.bike_station_longitude))!
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.map = mapView
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: "flag_2_filled")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        marker.iconView = imageView
        self.mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D.init(latitude: lat, longitude:  long), zoom: 15, bearing: 0, viewingAngle: 0)
        
    }
    
    @IBAction func arrivedStation(){
        let defaults = UserDefaults.standard
        let fullId = defaults.value(forKey: FULLID_KEY) as! Int
        let alert = UIAlertController(title: "รายงานจุดจอด", message: "คุณถึงจุดจอด \(station.bike_station_name) เรียบร้อยแล้ว?" , preferredStyle: UIAlertControllerStyle.alert)
        
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
