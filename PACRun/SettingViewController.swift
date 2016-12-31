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

    override func viewDidLoad() {
        super.viewDidLoad()
        distanceAndTimeLabel.text = String(Int(distanceAndTimeSlider.value))
        tempoLabel.text = String(Int(tempoSlider.value))



    }
    override func viewWillAppear(_ animated: Bool) {
        player?.stop()
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



    @IBAction func startButton(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StopViewController") as! StopViewController
        //開始計時
        controller.start()
        //設定開始記錄
        GPSManager.sharedInstance.isRecord = true
        GPSManager.sharedInstance.isPause = false
        //設定目標距離跟tempo
        controller.objectDistance = Int(distanceAndTimeLabel.text!)
        controller.tempoSpeed = Int(tempoLabel.text!)
        //切換頁面
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

}
