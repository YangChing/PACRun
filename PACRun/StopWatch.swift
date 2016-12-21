//
//  StopWatch.swift
//  PACRun
//
//  Created by 馮仰靚 on 20/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import Foundation

class StopWatch: NSObject {
    var startTimer : NSDate?
    var currentTimer : NSDate?
    var duration : TimeInterval?
    var timer : Timer?
    var stopDuration : TimeInterval = 0

    func start(){
        if timer == nil { //Start Timer
            timer = Timer()
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StopWatch.updateTimer), userInfo: nil, repeats: true)
            startTimer = NSDate()
        }
        else {
            //Don't start Timer
        }
        print("date:")
    }

    func updateTimer(){
        currentTimer = NSDate()
        if startTimer != nil {
            duration = (currentTimer?.timeIntervalSince(startTimer! as Date))! + stopDuration

            //NotificationCenter.default.post(name: NSNotification.Name("stopwatchTime"), object: nil, userInfo: ["time": dateStringFromTimeInterval(timeInterval: duration!) ])
            //  timeLabel.text = dateStringFromTimeInterval(duration!)
        }
    }

    func stop(){
        if duration != nil {
            stopDuration = duration!
        }
        timer?.invalidate()
        timer = nil
    }

    func reset(){
        timer?.invalidate()
        timer = nil
        startTimer = nil
        currentTimer = nil
        stopDuration = 0
       // timeLabel.text = dateStringFromTimeInterval(0)
    }

    func dateStringFromTimeInterval(timeInterval : TimeInterval) -> String{
        var formater = DateFormatter()
        formater.dateFormat = "HH:mm:ss.SS"
        formater.timeZone = NSTimeZone(name: "GMT") as TimeZone!

        var date = NSDate(timeIntervalSince1970: timeInterval)


        return formater.string(from: date as Date)
    }

}
