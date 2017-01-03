//
//  RecordViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 31/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecordViewController: UIViewController {


    @IBOutlet weak var beforeRecordLabel: UILabel!

    @IBOutlet weak var nowRecordLabel: UILabel!
    
    @IBOutlet weak var bestRecordLabel: UILabel!

    @IBOutlet weak var speedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "紀錄"
        var user_id : String = "0"
        Alamofire.request("https://i-running.ga/api/users").responseJSON { response in
            //https://i-running.ga/api/user/user_id/records
            switch response.result{
            case .success:
                let json = JSON(response.result.value)
                //print("JSON: \(json)")
                let count = json.count
                for i in 0...(json.count-1){
                    if json[i]["fb_uid"].stringValue  == userDefault.value(forKey: nowUserKey) as? String{
                        user_id = json[i]["id"].stringValue
                        print("userid=\(user_id)")

                        Alamofire.request("https://i-running.ga/api/users/\(user_id)/records").responseJSON { response in
                            switch response.result{
                            case .success:
                                let json = JSON(response.result.value)
                                //print("JSON: \(json)")
                                var bigID:Int = 0
                                for i in 0...(json.count-1){
                                    if json[i]["id"].intValue > bigID {
                                        bigID = i
                                        print("bigID\(bigID)")
                                    }
                                }
                                self.nowRecordLabel.text = json[bigID]["time"].stringValue
                                print("time:\(json[bigID]["time"].stringValue)")
                                self.speedLabel.text = "均速：" + json[bigID]["velocity"].stringValue + "km/hr"

                                var time = [String]()
                                time.append(json[bigID-1]["date"].stringValue)
                                for ele in time {
                                    let get = ele.components(separatedBy: " ")
                                    print("======\n",get)   // 拆解後長相 ["Au", "Day1" ]

                                    self.beforeRecordLabel.text = "上次紀錄" + "\(get[0])" +  json[bigID-1]["time"].stringValue
                                }


                            case .failure:
                                print("error")
                            }
                        }


                    }
                }
                Alamofire.request("https://i-running.ga/api/users/\(user_id)/records/fast").responseJSON { response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        print("JSON: \(json)")
                        var time = [String]()
                        time.append(json["record"]["date"].stringValue)


                        for ele in time {
                            let get = ele.components(separatedBy: " ")
                            print("======\n",get)   // 拆解後長相 ["Au", "Day1" ]

                            self.bestRecordLabel.text = "最佳紀錄" + "\(get[0])" +  json["record"]["time"].stringValue
                        }
                    case .failure:
                        print("error")
                    }
                }
                //
            case .failure:
                print("error")
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeButton(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)

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
extension RecordViewController : UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell



        // Configure the cell...

        return cell
    }

}
