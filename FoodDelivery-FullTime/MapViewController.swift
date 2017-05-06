//
//  MapViewController.swift
//  FoodDelivery-FullTime
//
//  Created by Kewalin Sakawattananon on 4/14/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class MapViewController: BaseViewController, GMSMapViewDelegate{
    
    @IBOutlet var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var firstLoc:CLLocationCoordinate2D? = nil
    var curSeq:SeqOrder? = nil
    var rate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "แผนที่เดินทาง"
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        // let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: CLLocationDegrees.init("13.7383829")!, longitude: CLLocationDegrees.init("100.5298641")!))
   //    self.setupPin()
   //     self.getMapList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.resetMap()
        self.getMapList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPin(order:Order){
        self.rate = order.order_delivery_rate

        var preOrder:SeqOrder? = nil
        var markers:[GMSMarker] = []
        
        // Current Loc
        /*
        let marker = GMSMarker()
        let curLoc = GlobalVariables.sharedManager.currentLocation
        let mesLat = (curLoc?.latitude)!
        let mesLong = (curLoc?.longitude)!
        */
        // Bike STation
        let station = GlobalVariables.sharedManager.curBikeStation
        let stationMarker = GMSMarker()
        stationMarker.title = "Stop 1"
        let stationLat = Double.init(station.bike_station_latitude)!
        let stationLong = Double.init(station.bike_station_longitude)!
        stationMarker.position = CLLocationCoordinate2DMake(stationLat, stationLong)
        stationMarker.map = mapView
        
        
        let imageViewStation = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageViewStation.image = UIImage(named: "flag_2_filled")
        imageViewStation.contentMode = UIViewContentMode.scaleAspectFit
        stationMarker.iconView = imageViewStation
        stationMarker.userData = [ISMER_KEY : false, STATION_KEY : station]
        markers.append(stationMarker)
        
        for seqOrder in order.seqOrders {
            
            let marker = GMSMarker()
 //           marker.title = seqOrder.merchant.merName
            marker.userData = [ISMER_KEY : true, SEQORDER_KEY : seqOrder]
            //marker.infoWindowAnchor = CGPoint.init(x: 0, y: 0)
            //marker.appearAnimation = .pop
//            marker.
            let lat = Double.init(seqOrder.merchant.merLatitude)
            let long = Double.init(seqOrder.merchant.merLongtitude)
            marker.position = CLLocationCoordinate2DMake(lat!,long!)
            marker.map = mapView
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            if seqOrder.seqor_receive_status_id == MERCHANT_RECEIVED_STATUS {
                imageView.image = UIImage(named: "location_green_filled")
            }else{
                imageView.image = UIImage(named: "location_orange_filled")
            }
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            let seq = UILabel(frame: CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height - 5))
            seq.text = "\(seqOrder.seqor_sort)"
            seq.font = UIFont.boldSystemFont(ofSize: 14)
            seq.textColor = UIColor.white
            seq.contentMode = UIViewContentMode.center
            seq.textAlignment = NSTextAlignment.center
            imageView.addSubview(seq)
            marker.iconView = imageView

            markers.append(marker)
            
            //path.add(CLLocationCoordinate2D(latitude: lat!, longitude: long!))
            if seqOrder.seqor_sort == 1 {
                firstLoc = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                self.curSeq = seqOrder
            }
            if preOrder != nil {
                if preOrder?.seqor_receive_status_id == MERCHANT_RECEIVED_STATUS && seqOrder.seqor_receive_status_id != MERCHANT_RECEIVED_STATUS {
                    self.googleApi(preLatitude: (preOrder?.merchant.merLatitude)!, preLongitude: (preOrder?.merchant.merLongtitude)!, postLatitude: seqOrder.merchant.merLatitude, postLongitude: seqOrder.merchant.merLongtitude)
                }
            }else{
                if seqOrder.seqor_receive_status_id != MERCHANT_RECEIVED_STATUS {
                    self.googleApi(preLatitude:  "\(station.bike_station_latitude)", preLongitude: "\(station.bike_station_longitude)", postLatitude: seqOrder.merchant.merLatitude, postLongitude: seqOrder.merchant.merLongtitude)
                }
            }
            preOrder = seqOrder
        }
        
        let customerMarker = GMSMarker()
        customerMarker.title = "Stop 1"
        let orderlat = Double.init(order.order_address_latitude)!
        let orderLong = Double.init(order.order_address_longtitude)!
        customerMarker.position = CLLocationCoordinate2DMake(orderlat, orderLong)
        customerMarker.map = mapView
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: "gender_neutral_user_filled")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        customerMarker.iconView = imageView
        customerMarker.userData = [ISMER_KEY : false, ORDER_KEY : order]
        markers.append(customerMarker)
        
        if preOrder != nil && order.order_status_id == ORDER_DELIVERING_STATUS {
            self.googleApi(preLatitude: (preOrder?.merchant.merLatitude)!, preLongitude: (preOrder?.merchant.merLongtitude)!, postLatitude: "\(orderlat)", postLongitude: "\(orderLong)")
        }
        
        /*
        // Station
        if station != nil {
            let stationMarker = GMSMarker()
            stationMarker.title = "Stop 1"
            let stationLat = Double.init(station.bike_station_latitude)!
            let stationLong = Double.init(station.bike_station_longitude)!
            stationMarker.position = CLLocationCoordinate2DMake(stationLat, stationLong)
            stationMarker.map = mapView
        
        
            let imageViewStation = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imageViewStation.image = UIImage(named: "flag_2_filled")
            imageViewStation.contentMode = UIViewContentMode.scaleAspectFit
            stationMarker.iconView = imageViewStation
            stationMarker.userData = [ISMER_KEY : false, STATION_KEY : station]
            markers.append(stationMarker)
        
            self.googleApi(preLatitude: "\(orderlat)", preLongitude: "\(orderLong)", postLatitude: "\(stationLat)", postLongitude: "\(stationLong)")
        }*/
            self.fitAllMarkers(markers: markers)
        
       /*
        path.add(CLLocationCoordinate2D(latitude: lat!, longitude: long!))
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeColor = UIColor.red
        rectangle.strokeWidth = 2
        rectangle.map = mapView
        */
        /*
        var bounds = GMSCoordinateBounds()
        
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        mapView.animate(toZoom: 15)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))*/
    }
    
    func resetMap(){
        self.mapView.clear()
        
       // self.setupPin(order:Order)
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

       // var infoWindow = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let infoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?.first as! CustomInfoWindow
        
        let data = marker.userData as! NSDictionary
        let isMer = data[ISMER_KEY] as! Bool
        if isMer {
            infoWindow.merName.text = (data[SEQORDER_KEY] as! SeqOrder).merchant.merName
            infoWindow.typeLbl.text = MERCHANT
            if (data[SEQORDER_KEY] as! SeqOrder).seqor_receive_status_id == MERCHANT_RECEIVED_STATUS {
                infoWindow.headerView.backgroundColor = GREEN
            }else{
                infoWindow.headerView.backgroundColor = ORANGE
            }
        }else {
            if data[ORDER_KEY] != nil {
                infoWindow.merName.text = (data[ORDER_KEY] as! Order).customer.cus_name
                infoWindow.typeLbl.text = CUSTOMER
            }else{
                infoWindow.detailImg.isHidden = true
                infoWindow.merName.text = (data[STATION_KEY] as! BikeStation).bike_station_name
                infoWindow.typeLbl.text = STATION
            }
        }
        infoWindow.layer.cornerRadius = 20.0
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let data = marker.userData as! NSDictionary
        let isMer = data[ISMER_KEY] as! Bool
        if isMer {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderPerMerchantViewController") as? OrderPerMerchantViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                    viewController.deliveryRate = rate
                    viewController.order = (data[SEQORDER_KEY]  as! SeqOrder)
                }
            }
        }else {
            if data[ORDER_KEY] != nil {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerViewController") as? CustomerViewController {
                    if let navigator = navigationController {
                        navigator.pushViewController(viewController, animated: true)
                        viewController.order = (data[ORDER_KEY]  as! Order)
                    }
                }
            }else{
                /*
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationViewController") as? StationViewController {
                    if let navigator = navigationController {
                        navigator.pushViewController(viewController, animated: true)
                        viewController.station = (data[STATION_KEY]  as! BikeStation)
                    }
                }*/
            }
        }
    }
    
    func fitAllMarkers(markers:[GMSMarker])
    {
        var bounds = GMSCoordinateBounds()
        for marker in markers
        {
            bounds = bounds.includingCoordinate(marker.position)
        }
        mapView.animate(toZoom: 10)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
        
    }
    
    func googleApi(preLatitude:String, preLongitude:String, postLatitude:String, postLongitude:String){
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(preLatitude),\(preLongitude)&destination=\(postLatitude),\(postLongitude)&avoid=tolls&key=\(GOOGLEMAP_KEY)")
        print("url \(url)")
        Alamofire.request(url!).responseJSON{ response in
                if let JSON = response.result.value {
                    print("JSON \(JSON)")
                    let mapResponse: [String: AnyObject] = JSON as! [String : AnyObject]
                    let routesArray = (mapResponse["routes"] as? Array) ?? []
                    let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
                    let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
                    let polypoints = (overviewPolyline["points"] as? String) ?? ""
                    let line  = polypoints
                    
                    self.addPolyLine(encodedString: line)
                }
        }
        
    }
    
    func addPolyLine(encodedString: String) {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2
        polyline.strokeColor = UIColor.blue
        polyline.map = mapView
        
    }
    
    func getMapList(){
        
        let order = GlobalVariables.sharedManager.curOrder
        order.seqOrders = order.seqOrders.sorted { $0.seqor_sort < $1.seqor_sort }
        if order.order_status_id == ORDER_RECEIVED_STATUS {
            
        }else{
            self.setupPin(order: order)
        }
        
        /*
        if let path = Bundle.main.path(forResource: "assignment", ofType: "json")
        {
            if let jsonData = NSData (contentsOfFile: path)
            {
                do {
                    if let jsonResult: NSMutableDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary   {
                        print("jsonResult \(jsonResult)")
                        if (jsonResult.object(forKey: DATA_KEY) != nil) {
                            let dataDict = jsonResult.object(forKey: DATA_KEY) as! NSMutableDictionary
                            let orderDict = dataDict.object(forKey: ORDER_KEY) as! NSMutableDictionary
                            let stationDict = dataDict.object(forKey: STATION_KEY) as! NSMutableDictionary
                            let order = Order(json: orderDict)
                            order.seqOrders = order.seqOrders.sorted { $0.seqor_sort < $1.seqor_sort }
                            let station = BikeStation(json: stationDict)
                            self.setupPin(order: order, station: station)
                            
                        }
                    }
                } catch _ {
                    print("error")
                }
            }
        }*/
        
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
// Mark: -CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if curSeq != nil {
            let merLoc = CLLocation.init(latitude: Double.init((curSeq?.merchant.merLatitude)!)!, longitude: Double.init((curSeq?.merchant.merLongtitude)!)!)
                if Double.init((merLoc.distance(from: location))) < 100.00 {
                    curSeq?.seqor_receive_status = "Arrived"
                    self.getMapList()
                    curSeq = nil
                }
            }
            
             /*
            if   firstLoc != nil {
            //self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            print("update")
            let path = GMSMutablePath()
            path.add(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            path.add(firstLoc!)
            let rectangle = GMSPolyline(path: path)
            rectangle.strokeColor = UIColor.green
            rectangle.strokeWidth = 2
            rectangle.map = mapView
            
                let marker = GMSMarker()
                marker.title = "Stop 1"
                marker.position = location.coordinate
                marker.map = mapView
                
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                imageView.image = UIImage(named: "motorcycle_filled")
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                marker.iconView = imageView
            locationManager.stopUpdatingLocation()
            }*/
        }
    }
}

