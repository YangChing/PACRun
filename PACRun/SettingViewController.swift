//
//  SettingViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 18/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit


class SettingViewController: UIViewController {

    //Label
    @IBOutlet weak var distanceAndTimeLabel: UILabel!
    @IBOutlet weak var distanceAndTimeSlider: UISlider!
    @IBOutlet weak var distanceAndTimeUnit: UILabel!

    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tempoSlider: UISlider!

    //距離跟時間的Button
    @IBOutlet weak var distanceLabel: UIButton!
    @IBOutlet weak var timeLabel: UIButton!

    var isTime = false



    override func viewDidLoad() {
        super.viewDidLoad()
        distanceAndTimeLabel.text = String(Int(distanceAndTimeSlider.value))
        tempoLabel.text = String(Int(tempoSlider.value))



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
   

    @IBAction func distanceAndTimerSelector(_ sender: Any) {

        distanceAndTimeLabel.text = String(Int(distanceAndTimeSlider.value))

    }


    @IBAction func tempoSelector(_ sender: Any) {

        tempoLabel.text = String(Int(tempoSlider.value))
    }


    @IBAction func setTimeButton(_ sender: Any) {
        isTime = true
        distanceAndTimeUnit.text = "min"

        //distanceLabel.titleLabel?.textColor = UIColor.gray
        //timeLabel.titleLabel?.textColor = UIColor.white


        distanceLabel.setTitleColor(UIColor.gray, for: .normal)
        timeLabel.setTitleColor(UIColor.white, for: .normal)

        distanceAndTimeSlider.minimumValue = 10
        distanceAndTimeSlider.maximumValue = 300
        distanceAndTimeSlider.value = 155
        distanceAndTimeLabel.text  = "155"


    }


    @IBAction func setDistanceButton(_ sender: Any) {

        isTime = false
        distanceAndTimeUnit.text = "km"
        //timeLabel.titleLabel?.textColor = UIColor.gray
       //distanceLabel.titleLabel?.textColor = UIColor.white
        distanceLabel.setTitleColor(UIColor.white, for: .normal)
         timeLabel.setTitleColor(UIColor.gray, for: .normal)
        distanceAndTimeSlider.minimumValue = 0
        distanceAndTimeSlider.maximumValue = 10
        distanceAndTimeSlider.value = 5

        distanceAndTimeLabel.text  = "5"
    }


    @IBAction func startButton(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StopViewController") as! StopViewController
        controller.start()
        GPSManager.sharedInstance.isRecord = true
        controller.objectDistance = Int(distanceAndTimeLabel.text!)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

}
