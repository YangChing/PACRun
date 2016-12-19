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
        latitude = GPSManager.sharedInstance.GPSCoordinate?.latitude
        longitude = GPSManager.sharedInstance.GPSCoordinate?.longitude
        NotificationCenter.default.addObserver(self, selector: #selector(StreetViewController.didUpdateCoordinate(date:)), name: NSNotification.Name(rawValue: "updateCoordinate"), object: nil)
        self.view.addSubview(backToButton)
    }
    override func viewWillAppear(_ animated:Bool) {
        navigationController?.navigationBar.isHidden = true
        self.mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.forMapUIVIew.frame.height))
        self.forMapUIVIew.addSubview(mapView!)
        self.mapView?.camera = GMSCameraPosition.camera(withLatitude: self.latitude!,longitude:self.longitude! , zoom: 16)
        //顯示自己的位置
        self.mapView?.isMyLocationEnabled = true

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func backToButton(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: true)
    }

    func didUpdateCoordinate(date:Notification){
        if let dic = date.userInfo as? [String:CLLocationCoordinate2D]{

            let sydney = GMSCameraPosition.camera(withLatitude: (dic["GPSCoordinate"]?.latitude)!,
                                                  longitude:(dic["GPSCoordinate"]?.longitude)!, zoom: 16)
            self.mapView?.camera = sydney
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
