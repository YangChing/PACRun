//
//  GPSManager.swift
//  PACRun
//
//  Created by 馮仰靚 on 15/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import Foundation
import CoreLocation


//import GoogleMaps

class GPSManager:NSObject ,CLLocationManagerDelegate {
    static let sharedInstance = GPSManager()
    
    var GPSCoordinate:CLLocationCoordinate2D?
    var GPSHeading:Double?
    var locationManager = CLLocationManager()
    var speed : CLLocationSpeed?


    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var oldlastLocation: CLLocation!
    var traveledDistance:Double = 0
    //設定是否開始記錄
    var isRecord = false
    //是否點pause
    var isPause = false
    override init() {
        super.init()
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

        //開始傳送使用者的方向
        locationManager.startUpdatingHeading()
        //開始傳送使用者的位置
        locationManager.startUpdatingLocation()

        self.GPSCoordinate = locationManager.location?.coordinate
        self.GPSHeading = locationManager.heading?.trueHeading

    }
    //GPS位置改變時會執行
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.distanceFilter = 10
        let location = locations.first
        self.GPSCoordinate = location?.coordinate
        //GPS位置改變，post給其他Notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCoordinate"), object: nil, userInfo: ["GPSCoordinate":GPSCoordinate!])

        //判斷是否要開始記錄
        if isRecord == true {
            //第一次紀錄會給第一個位置
            if startLocation == nil {
                startLocation = locations.first
                oldlastLocation = locations.first
            //第二次後會進來此迴圈
            } else {
                
                if let lastLocation = locations.first {
                    let lastDistance = oldlastLocation.distance(from: lastLocation)
                    if lastDistance < 20 && lastDistance > 10{
                        if isPause == false {
                            traveledDistance += lastDistance
                        }
                        //print("tra:\(traveledDistance)")
                    }
                }
                oldlastLocation = locations.first
            }

        }

    }
    //Heading方向改變時會執行
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.GPSHeading = newHeading.trueHeading
        //Heading方向改變，post給其他Notification
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateHeading"), object: nil, userInfo: ["Heading":GPSHeading!])

    }
}
