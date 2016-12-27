//
//  MapViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 17/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController {
    
    let waypoint = [["lat": 34.685805, "lng": 135.520839],
                    ["lat": 34.681447, "lng": 135.533316],
                    ["lat": 34.666009, "lng": 135.528898],
                    ["lat": 34.667120, "lng": 135.500377],
                    ["lat": 34.692524, "lng": 135.501049],
                    ["lat": 34.692847, "lng": 135.525379],
                    ["lat": 34.694361, "lng": 135.501093],
                    ["lat": 34.666946, "lng": 135.500048],
                    ["lat": 34.667551, "lng": 135.479776],
                    ["lat": 34.674991, "lng": 135.481133],
                    ["lat": 34.667551, "lng": 135.479776],
                    ["lat": 34.666946, "lng": 135.500048],
                    ["lat": 34.655325, "lng": 135.497787],
                    ["lat": 34.654449, "lng": 135.505484],
                    ["lat": 34.659037, "lng": 135.490179],
                    ["lat": 34.649553, "lng": 135.490243],
                    ["lat": 34.649389, "lng": 135.497482],
                    ["lat": 34.623359, "lng": 135.490346],
                    ["lat": 34.620749, "lng": 135.475964],
                    ["lat": 34.609081, "lng": 135.473201],
                    ["lat": 34.627606, "lng": 135.432100],
                    ["lat": 34.630179, "lng": 135.438037],
                    ["lat": 34.638693, "lng": 135.436335],
                    ["lat": 34.637278, "lng": 135.427844],
                    ["lat": 34.641450, "lng": 135.422025],
                    ["lat": 34.640108, "lng": 135.414006],
                    ["lat": 34.6380876, "lng": 135.4161057]]


    @IBOutlet weak var forMapUIVIew: UIView!
    @IBOutlet weak var backToButton: UIButton!
    var latitude:Double?
    var longitude:Double?
    var mapView : GMSMapView?
    var marker = GMSMarker()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.latitude = GPSManager.sharedInstance.GPSCoordinate?.latitude
        self.longitude = GPSManager.sharedInstance.GPSCoordinate?.longitude
        NotificationCenter.default.addObserver(self, selector: #selector(StreetViewController.didUpdateCoordinate(date:)), name: NSNotification.Name(rawValue: "updateCoordinate"), object: nil)
       
    }
    override func viewWillAppear(_ animated:Bool) {
        //設定地圖的frame
        self.mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.forMapUIVIew.frame.height))
        self.forMapUIVIew.addSubview(mapView!)
        //設定camera的位置
        self.mapView?.camera = GMSCameraPosition.camera(withLatitude: self.latitude!,longitude:self.longitude! , zoom: 12)
        //是否顯示自己的位置
        self.mapView?.isMyLocationEnabled = true
        
       // addPolyLineWithEncodedStringInMap(encodedString: String)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func didUpdateCoordinate(date:Notification){
        if let dic = date.userInfo as? [String:CLLocationCoordinate2D]{
            //重新設定google camera的位置
            let sydney = GMSCameraPosition.camera(withLatitude: (dic["GPSCoordinate"]?.latitude)!,longitude:(dic["GPSCoordinate"]?.longitude)!, zoom: 16)
            //self.mapView?.camera = sydney
            //更新
            self.latitude = (dic["GPSCoordinate"]?.latitude)!
            self.longitude = (dic["GPSCoordinate"]?.longitude)!
        }
    }
    // 若Heading方向改變就會執行



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   }
