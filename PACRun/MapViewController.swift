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

class MapViewController: UIViewController ,GMSMapViewDelegate ,CLLocationManagerDelegate {


    
    @IBOutlet weak var streetView: UIView!

    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    var heading : Double = 0.0
    var pitch : Double = 0.0
    //Google map
    var panoView : GMSPanoramaView?


    var oldLatitude : String?
    var oldLongitude : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        //request
        self.locationManager.requestWhenInUseAuthorization()

        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //发送授权申请
        locationManager.requestAlwaysAuthorization()
        
           motionManager.startDeviceMotionUpdates()

        locationManager.startUpdatingHeading()

        locationManager.startUpdatingLocation()

        oldLatitude = String(format: "%.5f", (locationManager.location!.coordinate.latitude))
        oldLongitude = String(format: "%.5f", (locationManager.location!.coordinate.longitude))





    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        self.panoView = GMSPanoramaView(frame: CGRect(x: 0, y: 0, width: streetView.frame.width  , height: streetView.frame.height))
        self.view.addSubview(panoView!)

        panoView?.camera = GMSPanoramaCamera(heading: heading, pitch: -10, zoom: 1)
        panoView?.moveNearCoordinate((locationManager.location?.coordinate)!)

    }
    override func loadView() {

        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        /*let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
         */


   }


    @IBAction func getGyroscopeButton(_ sender: Any) {

    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //print("磁极方向：\(newHeading.magneticHeading)")
        //print("真实方向：\(newHeading.trueHeading)")
        heading = newHeading.trueHeading
        pitch = (motionManager.deviceMotion?.attitude.pitch)!
        print("pitch\(pitch)")
        //print("方向的精度：\(newHeading.headingAccuracy)")
        //print("时间：\(newHeading.timestamp)")
        viewWillAppear(true)
        panoView?.camera = GMSPanoramaCamera(heading: heading, pitch: -10, zoom: 1)
        //panoView?.moveNearCoordinate(CLLocationCoordinate2D(latitude: -33.732, longitude: 150.312))

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let a = Double(oldLongitude!)! - Double(String(format: "%.5f", (location?.coordinate.longitude)!))!
        let b = Double(oldLatitude!)! - Double(String(format: "%.5f", (location?.coordinate.latitude)!))!
        print("old:\(oldLongitude!),now:\(String(format: "%.5f", (location?.coordinate.longitude)!))")
        if sqrt(a*a + b*b) > 0.00012 {
            oldLongitude = String(format: "%.5f", (location?.coordinate.longitude)!)
            oldLatitude = String(format: "%.5f", (location?.coordinate.latitude)!)
        panoView?.moveNearCoordinate(CLLocationCoordinate2D(latitude: Double(oldLatitude!)!, longitude: Double(oldLongitude!)!))
        }

    }

}

