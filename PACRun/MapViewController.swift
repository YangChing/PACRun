//
//  MapViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 17/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {


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
        self.mapView?.camera = GMSCameraPosition.camera(withLatitude: self.latitude!,longitude:self.longitude! , zoom: 16)
        //是否顯示自己的位置
        self.mapView?.isMyLocationEnabled = true

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func didUpdateCoordinate(date:Notification){
        if let dic = date.userInfo as? [String:CLLocationCoordinate2D]{
            //重新設定google camera的位置
            let sydney = GMSCameraPosition.camera(withLatitude: (dic["GPSCoordinate"]?.latitude)!,
                                                  longitude:(dic["GPSCoordinate"]?.longitude)!, zoom: 16)
            self.mapView?.camera = sydney
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
