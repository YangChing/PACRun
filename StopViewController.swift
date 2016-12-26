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

class StopViewController: UIViewController {
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
    //設定目標距離
    var objectDistance : Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "停止"
        NotificationCenter.default.addObserver(self, selector: #selector(StopViewController.updateTimeLabel(date:)), name: NSNotification.Name("stopwatchTime"), object: nil)
        print("OBD:\(objectDistance)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            formater.dateFormat = "HH:mm:ss.SS"
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

        let distance = Double(round(meters)/1000)
        return String(distance)
    }

}
