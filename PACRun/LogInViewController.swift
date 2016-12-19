//
//  LogInViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 16/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GPSManager.sharedInstance.locationManager.requestAlwaysAuthorization()

        //產生 login 按鈕
        let loginButton = FBSDKLoginButton()
        //設定 login 按鈕的位置
        loginButton.frame = CGRect(x: 36, y: 399, width: 304, height: 55)
        //設定 loginButton 的 delegate
        loginButton.delegate = self
        //設定按鈕的權限
        loginButton.readPermissions = ["email","public_profile"]
        //把 login 按鈕加到畫面上
        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func nextButton(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
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
extension LogInViewController : FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print("登入失敗")
            print("*************\(error)")
            return
        }
        //取得使用者的資料
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start {
            (connection, results, error) in
            if error != nil{
                print("錯誤：\(error)")
                return
            }

            if let okResult = results as? [String:String] {
                //print(okResult["email"] ?? "")
                //1.拿到 Facebook accessToken
                let accessToken = FBSDKAccessToken.current()
                //2.用這個token產生 FIRAuthCredential
                guard let accessTokenString = accessToken?.tokenString else{ return }

                print("accessTokenString:\(accessTokenString)")
                // let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
                //登入FB資料


            }
        }
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
            print("log out")
    }
}

