//
//  SettingViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 18/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {


    @IBOutlet weak var distanceAndTimeLabel: UILabel!

    @IBOutlet weak var distanceAndTimeSlider: UISlider!


    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tempoSlider: UISlider!



    override func viewDidLoad() {
        super.viewDidLoad()
        distanceAndTimeLabel.text = String(Int(distanceAndTimeSlider.value))
        tempoLabel.text = String(Int(tempoSlider.value))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false

        self.title = "設定"
//        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func distanceAndTimerSelector(_ sender: Any) {

        distanceAndTimeLabel.text = String(Int(distanceAndTimeSlider.value))

    }


    @IBAction func tempoSelector(_ sender: Any) {

        tempoLabel.text = String(Int(tempoSlider.value))
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
