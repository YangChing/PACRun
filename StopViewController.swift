//
//  StopViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 18/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import CoreLocation

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

    let runRecord : RunRecordManager? = nil


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "停止"
        NotificationCenter.default.addObserver(self, selector: #selector(StopViewController.updateTimeLabel(date:)), name: NSNotification.Name("stopwatchTime"), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pauseButton(_ sender: Any) {
        GPSManager.sharedInstance.isRecord = false
        self.pause()
        self.startAndStopView.isHidden = false
        self.pauseButton.isHidden = true


    }

    @IBAction func stopButton(_ sender: Any) {
        GPSManager.sharedInstance.isRecord = false
        self.stop()

    }

    @IBAction func playButton(_ sender: Any) {
        GPSManager.sharedInstance.isRecord = true
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
extension StopViewController {

        func start(){
            if timer == nil { //Start Timer
                timer = Timer()
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StopWatch.updateTimer), userInfo: nil, repeats: true)
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
            //record distance

            //runRecord?.allCoordinate?.append(GPSManager.sharedInstance.GPSCoordinate!)

            
            ///////////////////
            return formater.string(from: date as Date)
        }
        
  
}
