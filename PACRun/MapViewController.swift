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


    @IBOutlet weak var backToButton: UIButton!

    var camera = GMSCameraPosition.camera(withLatitude: (GPSManager.sharedInstance.GPSCoordinate?.latitude)!,
                                          longitude:(GPSManager.sharedInstance.GPSCoordinate?.longitude)!, zoom: 16)
    var mapView : GMSMapView?
    var marker = GMSMarker()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(StreetViewController.didUpdateCoordinate(date:)), name: NSNotification.Name(rawValue: "updateCoordinate"), object: nil)

         self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)

        self.mapView?.isMyLocationEnabled = true
        self.view = mapView
/*
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake((GPSManager.sharedInstance.GPSCoordinate?.latitude)!, (GPSManager.sharedInstance.GPSCoordinate?.longitude)!)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        // Do any additional setup after loading the view.
 */
        self.view.addSubview(backToButton)
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
