//
//  MainNavigationController.swift
//  PACRun
//
//  Created by 馮仰靚 on 18/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(#imageLiteral(resourceName: "Navigation Bar"), for: .default)
        // Sets shadow (line below the bar) to a blank image
        //UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        //UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
       // UINavigationBar.appearance().isTranslucent = true


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
