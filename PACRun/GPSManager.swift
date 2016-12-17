//
//  GPSManager.swift
//  PACRun
//
//  Created by 馮仰靚 on 15/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class GPSManager:NSObject ,CLLocationManagerDelegate {
    
    static let sharedInstance = GPSManager()
    var GPSCoordinate:CLLocationCoordinate2D?
    var GPSHeading:Double?
    var locationManager = CLLocationManager()

    
    init(GPScoordinate:CLLocationCoordinate2D? = nil , GPSHeading :Double? = nil) {
        super.init()
        self.GPSCoordinate = GPScoordinate
        self.GPSHeading = GPSHeading

        //let motionManager = CMMotionManager()
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //发送授权申请
       // locationManager.requestWhenInUseAuthorization()

        locationManager.requestAlwaysAuthorization()

        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //設定delegate為自己
        locationManager.delegate = self
        //設定多少距離傳送
        locationManager.distanceFilter = 50
        //開始傳送使用者的方向
        locationManager.startUpdatingHeading()
        //開始傳送使用者的位置
        locationManager.startUpdatingLocation()

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.first
        self.GPSCoordinate = location?.coordinate
        print("GPScoordinate:\(GPSCoordinate)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCoordinate"), object: nil, userInfo: ["GPSCoordinate":GPSCoordinate!])

       // NotificationCenter.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.GPSHeading = newHeading.trueHeading
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateHeading"), object: nil, userInfo: ["Heading":GPSHeading!])

    }
}

