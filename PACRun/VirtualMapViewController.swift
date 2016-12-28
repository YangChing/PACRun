//
//  VirtualMapViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 28/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import GoogleMaps
import Alamofire
import SwiftyJSON

class VirtualMapViewController: UIViewController {


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

    var isDistanceChange : Int = 0
    var myPoint : CLLocationCoordinate2D?
    var mylocation : GMSMarker?

    //設定地圖所需的變數
    var latitude:Double?
    var longitude:Double?
    var mapView : GMSMapView?
    var marker = GMSMarker()

    override func viewDidLoad() {
        super.viewDidLoad()

        myPoint = CLLocationCoordinate2DMake(self.latitude!, self.longitude!)
        NotificationCenter.default.addObserver(self, selector: #selector(VirtualMapViewController.movePoint(date:)), name: NSNotification.Name(rawValue: "updatePointCount"), object: nil)


    }
    override func viewWillAppear(_ animated: Bool) {
        self.mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))

        self.view.addSubview(mapView!)

        //關閉google map 的功能
        //self.mapView?.settings.scrollGestures = false
        //self.mapView?.settings.rotateGestures = false
        //self.mapView?.settings.zoomGestures = false

        //標示起始點的位置
        let startPoint = CLLocationCoordinate2DMake(34.683298, 135.52167)
        let location1 = GMSMarker(position: startPoint)
        //location1.title = "London";
        // london1.icon = UIImage(named: "house")
        location1.map = mapView;
        //標示終點的位置
        let endPoint = CLLocationCoordinate2DMake(34.6380876, 135.4161057)
        let location2 = GMSMarker(position: endPoint)
        location2.map = mapView;

        //設定camera的可視範圍
        let vancouver = CLLocationCoordinate2DMake(34.680298, 135.54067)
        let calgary = CLLocationCoordinate2DMake(34.6300876, 135.4001057)
        let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
        self.mapView?.camera = (mapView?.camera(for: bounds, insets: UIEdgeInsets.zero))!
        //self.mapView?.camera = GMSCameraPosition.camera(withLatitude: self.latitude!,longitude:self.longitude! , zoom: 13)
        //設定類型
        self.mapView?.mapType = kGMSTypeTerrain
        //
        //是否顯示自己的位置
        self.mapView?.isMyLocationEnabled = true

        //繪製路徑
        let draw = DrawRoute()
        draw.mapView = self.mapView
        for i in 0...25 {
            draw.addOverlayToMapView(originLat: waypoint[i]["lat"]!, originLon: waypoint[i]["lng"]!, destinationLat: waypoint[i+1]["lat"]!, destinationLon: waypoint[i+1]["lng"]!)
        }
        
        mylocation = GMSMarker(position: myPoint!)
        mylocation?.icon = UIImage(named: "Goal_point")
        mylocation?.map = mapView;

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func movePoint(date:NSNotification){

        if let dic = date.userInfo as? [String:String]{
            //重新設定google camera的位置
            let pointCount = dic["point_count"]
            //判斷距離移動才去後台取點的位置

            Alamofire.request("https://i-running.ga/api/marathons/osaka/coordinates/\(pointCount!)").responseJSON { response in
                switch response.result{
                case .success:
                    let json = JSON(response.result.value)
                    print("JSON: \(json)")
                    let virLatitude = json["coordinate"]["latitude"].stringValue
                    let virLongitude = json["coordinate"]["longitude"].stringValue
                    self.mylocation?.map = nil
                    print("virLongitude:\(virLongitude)")
                    self.myPoint = CLLocationCoordinate2D(latitude: Double(virLatitude)!,longitude: Double(virLongitude)!)
                    self.mylocation = GMSMarker(position: self.myPoint!)
                    self.mylocation?.icon = UIImage(named: "Goal_point")
                    self.mylocation?.map = self.mapView
                case .failure:
                    print("error")
                }
                
            }
        }
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
