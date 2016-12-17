//
//  ViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 09/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit
import CoreMotion

class StreetViewController: UIViewController ,GMSMapViewDelegate  {

    @IBOutlet weak var streetView: UIView!

    var heading : Double = 0
    //Google map
    var panoView : GMSPanoramaView?

    var coordinateValue : CLLocationCoordinate2D? = GPSManager.sharedInstance.GPSCoordinate

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(StreetViewController.didUpdateCoordinate(date:)), name: NSNotification.Name(rawValue: "updateCoordinate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StreetViewController.didUpdateHeading(date:)), name: NSNotification.Name(rawValue: "updateHeading"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  override func loadView() {
    self.panoView = GMSPanoramaView(frame: .zero)
    self.view = panoView
    panoView?.camera = GMSPanoramaCamera(heading: heading, pitch: -10, zoom: 1)
    panoView?.moveNearCoordinate(coordinateValue!)
    print("loadView*********")
    }
    func didUpdateCoordinate(date:Notification){
        if let dic = date.userInfo as? [String:CLLocationCoordinate2D]{
            self.coordinateValue = dic["GPSCoordinate"]
             panoView?.moveNearCoordinate(coordinateValue!)
        }
    }
    func didUpdateHeading(date:Notification){
        if let dic = date.userInfo as? [String:Double]{
            self.heading = dic["Heading"]!
            panoView?.camera = GMSPanoramaCamera(heading: self.heading, pitch: -10, zoom: 1)
        }
    }

}

