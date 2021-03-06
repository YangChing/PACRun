//
//  VirtualStreetViewController.swift
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


class FinishStreetViewController: UIViewController {

    //======street view
    //Google map
    var panoView : GMSPanoramaView?
    //用來儲存heading方線的變數：單位是“度” 0~360
    var heading : Double = 0
    //用來儲存座標的變數
    var coordinateValue : CLLocationCoordinate2D?
    //==================================
    var myPoint : CLLocationCoordinate2D?
    var latitude:Double?
    var longitude:Double?
    //
    var distance:Double?
    var oldDistance:Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        //myPoint = CLLocationCoordinate2DMake(self.latitude!, self.longitude!)
        //NotificationCenter.default.addObserver(self, selector: #selector(VirtualMapViewController.movePoint(date:)), name: NSNotification.Name(rawValue: "updatePointCount"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.panoView = GMSPanoramaView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(panoView!)
        panoView?.camera = GMSPanoramaCamera(heading: heading, pitch: -10, zoom: 1)
        if let coordinate = myPoint {
            panoView?.moveNearCoordinate(coordinate)
        }

        if Int(distance!) >= 2 {
            for n in 1...(Int(distance!)){
                self.delay(Double(n)*1.5){
                    self.autoRunStreetview(i: n)
                }
            }
        }


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    func movePoint(date:NSNotification){

        if let dic = date.userInfo as? [String:String]{
            //重新設定google camera的位置
            let pointCount = dic["point_count"]

            if Int(pointCount!)! < 448 {
                Alamofire.request("https://i-running.ga/api/marathons/osaka/coordinates/\(pointCount!)").responseJSON { response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        print("JSON: \(json)")
                        let virLatitude = json["coordinate"]["latitude"].stringValue
                        let virLongitude = json["coordinate"]["longitude"].stringValue
                        let heading =  json["coordinate"]["heading"].stringValue
                        self.myPoint = CLLocationCoordinate2D(latitude: Double(virLatitude)!,longitude: Double(virLongitude)!)
                        self.coordinateValue = self.myPoint
                        self.panoView?.camera = GMSPanoramaCamera(heading: Double(heading)!, pitch: -10, zoom: 1)
                        self.panoView?.moveNearCoordinate(self.coordinateValue!)

                    case .failure:
                        print("error")
                    }
                }
            }
        }
    }

    func autoRunStreetview(i:Int){

        if i < 448 {
            Alamofire.request("https://i-running.ga/api/marathons/osaka/coordinates/\(i)").responseJSON { response in
                switch response.result{
                case .success:
                    let json = JSON(response.result.value)
                    print("JSON: \(json)")
                    let virLatitude = json["coordinate"]["latitude"].stringValue
                    let virLongitude = json["coordinate"]["longitude"].stringValue
                    let heading =  json["coordinate"]["heading"].stringValue
                    self.myPoint = CLLocationCoordinate2D(latitude: Double(virLatitude)!,longitude: Double(virLongitude)!)
                    self.coordinateValue = self.myPoint
                    self.panoView?.camera = GMSPanoramaCamera(heading: Double(heading)!, pitch: -10, zoom: 1)
                    self.panoView?.moveNearCoordinate(self.coordinateValue!)

                case .failure:
                    print("error")
                }
            }
        }
        // Put your code which should be executed with a delay here



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
