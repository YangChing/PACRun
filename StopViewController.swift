//
//  StopViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 18/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import GoogleMaps
import Alamofire
import SwiftyJSON

class StopViewController: UIViewController {

    var isDistanceChange : Int = 0
    var myPoint = CLLocationCoordinate2DMake(34.6380876, 135.4161057)
    var mylocation : GMSMarker?

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


    @IBOutlet weak var inStopStreetView: UIView!

    @IBOutlet weak var inStopMapView: UIView!

    @IBOutlet weak var mapViewButtonOutlet: UIButton!


    @IBOutlet weak var streetViewButtonOutlet: UIButton!
    
    //設定計時器的參數
    var startTimer : NSDate?
    var currentTimer : NSDate?
    var duration : TimeInterval?
    var timer : Timer?
    var stopDuration : TimeInterval = 0
    //
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startAndStopView: UIView!
    @IBOutlet weak var stopwatchLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    //建立紀錄物件
    let runRecord : RunRecordManager? = nil
    //設定目標距離跟tempo
    var objectDistance : Int?
    var tempoSpeed : Int?
    //設定地圖
    var latitude:Double?
    var longitude:Double?
    var mapView : GMSMapView?
    var marker = GMSMarker()
    //設定tempo

    @IBOutlet weak var tempoLabel: UILabel!


    let music = TempoManager()


    override func viewDidLoad() {
        super.viewDidLoad()

        //播放音樂=====
        if tempoSpeed == 0 {
            music.setRate = 0
        }else{
            music.setRate = Float(tempoSpeed!)/10 + 0.5
        }
        music.playSound()
        //=========
        tempoLabel.text = String(tempoSpeed!)
        //
        self.navigationItem.title = "跑步中"
        NotificationCenter.default.addObserver(self, selector: #selector(StopViewController.updateTimeLabel(date:)), name: NSNotification.Name("stopwatchTime"), object: nil)
        
        print("OBD:\(objectDistance)")
        //設定跑者在虛擬地圖的位置
        self.latitude = 34.683298
        self.longitude = 135.52167
       // NotificationCenter.default.addObserver(self, selector: #selector(StreetViewController.didUpdateCoordinate(date:)), name: NSNotification.Name(rawValue: "updateCoordinate"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        //設定地圖的frame
        self.mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.inStopMapView.frame.width, height: self.inStopMapView.frame.height))

        self.inStopMapView.addSubview(mapView!)
        //加入跳到map的按鈕
        self.mapView?.addSubview(mapViewButtonOutlet)
        //關閉google map 的功能
        self.mapView?.settings.scrollGestures = false
        self.mapView?.settings.rotateGestures = false
        self.mapView?.settings.zoomGestures = false

        //標示起始點的位置
        let startPoint = CLLocationCoordinate2DMake(34.683298, 135.52167)
        let location1 = GMSMarker(position: startPoint)
        location1.title = "London";
       // london1.icon = UIImage(named: "house")
        location1.map = mapView;
        //標示終點的位置
        let endPoint = CLLocationCoordinate2DMake(34.6380876, 135.4161057)
        let location2 = GMSMarker(position: endPoint)
      //  london2.title = "London";
      //  london2.icon = UIImage(named: "house")
        location2.map = mapView;

        //設定camera的位置
        let vancouver = CLLocationCoordinate2DMake(34.700298, 135.55067)
        let calgary = CLLocationCoordinate2DMake(34.6000876, 135.3901057)
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
        mylocation = GMSMarker(position: myPoint)
        mylocation?.icon = UIImage(named: "Goal_point")
        mylocation?.map = mapView;


    }
    @IBAction func pauseButton(_ sender: Any) {
        //Distance
        GPSManager.sharedInstance.isRecord = false
        GPSManager.sharedInstance.isPause = true
        //Time
        self.pause()
        self.startAndStopView.isHidden = false
        self.pauseButton.isHidden = true
    }

    @IBAction func stopButton(_ sender: Any) {
        //distance
        GPSManager.sharedInstance.isRecord = false
        distanceLabel.text = "00.000"
        GPSManager.sharedInstance.startLocation = nil
        GPSManager.sharedInstance.traveledDistance = 0
        //time
        self.stop()
    }

    @IBAction func playButton(_ sender: Any) {
        //distance
        GPSManager.sharedInstance.isRecord = true
        GPSManager.sharedInstance.isPause = false
        //time
        self.start()
        self.pauseButton.isHidden = false
        self.startAndStopView.isHidden = true
    }

    func updateTimeLabel(date:Notification) {
        if let dic = date.userInfo as? [String:String]{
            self.stopwatchLabel.text = dic["time"]
        }
    }

    @IBAction func tempoAddSpeed(_ sender: Any) {


        if tempoSpeed! <= 9  && tempoSpeed! >= 0{

            DispatchQueue.main.async {
                self.tempoLabel.text = String(Int(self.tempoSpeed!) + 1)
                self.tempoSpeed = self.tempoSpeed! + 1
                if self.tempoSpeed == 0 {
                    self.music.setRate = Float(self.tempoSpeed!) + 0.1

                }else{
                    self.music.setRate = (Float(self.tempoSpeed!))/10 + 0.5
                }
                self.music.playSound()
                print("tempospeed\(self.tempoSpeed!)")
                print("music.setRate\(self.music.setRate!)")
            }


        }
    }

    @IBAction func tempoSubstractSpeed(_ sender: Any) {

        if tempoSpeed! <= 10  && tempoSpeed! >= 1{

            DispatchQueue.main.async {
                self.tempoLabel.text = String(Int(self.tempoSpeed!) - 1)
                 self.tempoSpeed = self.tempoSpeed! - 1
                if self.tempoSpeed == 0 {
                   player?.stop()
                    self.music.setRate = 0.5
                }else{
                    self.music.setRate = (Float(self.tempoSpeed!))/10 + 0.5
                    self.music.playSound()
                }

                print("tempospeed\(self.tempoSpeed!)")
                print("music.setRate\(self.music.setRate!)")
            }

        }

    }


    @IBAction func mapButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func streetViewButton(_ sender: Any) {

    }



}
//計時器
extension StopViewController {

        func start(){
            if timer == nil { //Start Timer
                timer = Timer()
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StopViewController.updateTimer), userInfo: nil, repeats: true)
                startTimer = NSDate()
            }
            else {
                //Don't start Timer
            }
        }

        func updateTimer(){
            currentTimer = NSDate()
            if startTimer != nil {
                duration = (currentTimer?.timeIntervalSince(startTimer! as Date))! + stopDuration
                //設定計時器的文字
                  stopwatchLabel.text = dateStringFromTimeInterval(timeInterval: duration!)
            }
        }

        func pause(){
            if duration != nil {
                stopDuration = duration!
            }
            timer?.invalidate()
            timer = nil

        }

        func stop(){
            timer?.invalidate()
            timer = nil
            startTimer = nil
            currentTimer = nil
            stopDuration = 0
             stopwatchLabel.text = dateStringFromTimeInterval(timeInterval: 0)
        }

        func dateStringFromTimeInterval(timeInterval : TimeInterval) -> String{
            var formater = DateFormatter()
            formater.dateFormat = "HH:mm:ss"
            formater.timeZone = NSTimeZone(name: "GMT") as TimeZone!
            var date = NSDate(timeIntervalSince1970: timeInterval)
            //紀錄座標
            if runRecord?.startLocation == nil {
                runRecord?.startLocation = GPSManager.sharedInstance.GPSCoordinate
            }
            runRecord?.allCoordinate?.append(GPSManager.sharedInstance.GPSCoordinate!)
            //顯示現在的路程
            distanceLabel.text = formatDistance(meters: GPSManager.sharedInstance.traveledDistance)
            
            ///////////////////
            return formater.string(from: date as Date)
    }
    //距離轉換，從GPS獲得的距離，轉換後只取到公尺，顯示單位為公里
    func formatDistance(meters: Double) -> String {

        let distance = Double(round(meters/10)/100)
        self.movePoint(distance: Int(meters))
        return String(distance)
    }
    //移動自己的點
    func movePoint(distance:Int){
        if distance - isDistanceChange >= 1 {
            Alamofire.request("https://i-running.ga/api/marathons/osaka/coordinates/\(Int(distance/1))").responseJSON { response in
                switch response.result{
                case .success:
                    let json = JSON(response.result.value)
                    print("JSON: \(json)")
                    let virLatitude = json["coordinate"]["latitude"].stringValue
                    let virLongitude = json["coordinate"]["longitude"].stringValue
                    self.mylocation?.map = nil
                    print("virLongitude:\(virLongitude)")
                    self.myPoint = CLLocationCoordinate2D(latitude: Double(virLatitude)!,longitude: Double(virLongitude)!)
                    self.mylocation = GMSMarker(position: self.myPoint)
                    self.mylocation?.icon = UIImage(named: "Goal_point")
                    self.mylocation?.map = self.mapView
                case .failure:
                    print("error")
                }

            }
            isDistanceChange = distance
        }
    }
    
}
