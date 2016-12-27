//
//  SelectMapViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 20/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit

class SelectMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        player?.stop()
    }
    @IBAction func choiceMapButton(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(controller, animated: true)


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
