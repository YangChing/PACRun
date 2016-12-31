//
//  SelectMapViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 20/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SelectMapViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var myImage: UIImageView!

    @IBOutlet weak var selfSlider: UISlider!


    @IBOutlet weak var finishDistance: UILabel!

    @IBOutlet weak var leftDistance: UILabel!



    var selfImage : UIImageView?
    var slider : [UISlider] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(SelectMapViewController.runningRecord(_:)), name: NSNotification.Name(rawValue: "runningRecord"), object: nil)


        //獲取使用者資料
        NotificationCenter.default.addObserver(self, selector: #selector(SelectMapViewController.setImage(date:)), name: NSNotification.Name(rawValue: "setImage"), object: nil)

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        //判斷使用者是否已登入，若無則跳出登入頁面
        if userDefault.string(forKey: nowUserKey) == nil || userDefault.string(forKey: nowUserKey) == "" {
            let controller = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(controller, animated: true, completion: nil)

        }else{
            selfSlider.setThumbImage(setImageInSlider(userID: userDefault.value(forKey: nowUserKey)! as! String), for: .normal)


            Alamofire.request("https://i-running.ga/api/users").responseJSON { response in

                switch response.result{
                case .success:
                    let json = JSON(response.result.value)
                    //print("JSON: \(json)")
                    let count = json.count
                    for i in 0...(json.count-1){
                        if json[i]["fb_uid"].stringValue  == userDefault.value(forKey: nowUserKey) as? String{
                            let distance = json[i]["total_distance"].floatValue
                            print("distance:\(distance)")
                            self.finishDistance.text =  String(json[i]["total_distance"].floatValue)
                            self.leftDistance.text = String(44.7-json[i]["total_distance"].floatValue )
                                self.selfSlider.value = distance
                        }else{
                            let slider = UISlider()
                            slider.maximumValue = self.selfSlider.maximumValue
                            slider.minimumValue = self.selfSlider.minimumValue
                            slider.frame = self.selfSlider.frame
                            slider.setThumbImage(self.setImageInSlider(userID: json[i]["fb_uid"].stringValue), for: .normal)
                            slider.value = json[i]["total_distance"].floatValue

                            slider.maximumTrackTintColor = UIColor.clear
                            slider.minimumTrackTintColor = UIColor.clear
                            self.slider.append(slider)
                        }
                    }
                    for i in 0...(self.slider.count-1) {
                        self.stackView.addSubview(self.slider[i])
                    }
                    print("id:\(count)")
                case .failure:
                    print("error")
                }
            }

        }

        // 讀檔與寫檔
        var getOriginFileArray = [String]()
        //設定準備要讀取的檔案的路徑
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory , in: .userDomainMask)
        let home = paths.first?.appendingPathComponent("RecordLocation.txt")
        print("Home:\(home)")
        //讀取檔案內容
        let readArray2 = NSArray(contentsOf: home!)
        print(readArray2)
        if readArray2 != nil{
            for ele in readArray2!{
                if ele != nil {
                    getOriginFileArray.append(ele as! String)
                }
            }
        }
       let arrar = arrayFromContentsOfFileWithName(fileName: "RecordLocation")
        for n in arrar! {
            print("\(n)")
        }
        let parameters: Parameters = ["跑步紀錄":"1","時間":"01:15:39","距離":"10"]
        Alamofire.request("https://i-running.ga/api/records", method:.post, parameters: parameters, encoding: JSONEncoding.default )
                // Do any additional setup after loading the view.
    }
    func arrayFromContentsOfFileWithName(fileName: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }

        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch {
            return nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        player?.stop()
    }
    func setImage(date:Notification){

        if let dic = date.userInfo as? [String:String]{
            selfSlider.setThumbImage(setImageInSlider(userID: dic["userID"]!), for: .normal)
            Alamofire.request("https://i-running.ga/api/users").responseJSON { response in

                switch response.result{
                case .success:
                    let json = JSON(response.result.value)
                    //print("JSON: \(json)")
                    let count = json.count
                    for i in 0...(json.count-1){
                        if json[i]["fb_uid"].stringValue  == userDefault.value(forKey: nowUserKey) as? String{
                            let distance = json[i]["total_distance"].floatValue
                            self.finishDistance.text =  String(json[i]["total_distance"].floatValue)
                            self.leftDistance.text = String(44.7-json[i]["total_distance"].floatValue )
                            self.selfSlider.value = distance
                        }else{
                            let slider = UISlider()
                            slider.maximumValue = self.selfSlider.maximumValue
                            slider.minimumValue = self.selfSlider.minimumValue
                            slider.frame = self.selfSlider.frame
                            slider.setThumbImage(self.setImageInSlider(userID: json[i]["fb_uid"].stringValue), for: .normal)
                            slider.value = json[i]["total_distance"].floatValue


                            slider.maximumTrackTintColor = UIColor.clear
                            slider.minimumTrackTintColor = UIColor.clear
                            self.slider.append(slider)
                        }
                    }
                    for i in 0...(self.slider.count-1) {
                        self.stackView.addSubview(self.slider[i])
                    }

                case .failure:
                    print("error")
                }
            }
        }
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
        var imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer

        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)

        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
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
    func setImageInSlider(userID:String)->UIImage{
        let urlString = "https://graph.facebook.com/\(userID)/picture?type=large"
        print("\(urlString )")
        let url = URL(string : urlString)

            let data = try! Data(contentsOf:url!)
            let image = UIImage(data : data)
            let newImage = resizeImage(image: image!, targetSize: CGSize(width: 35, height: 35))
            let circleImage = newImage.circle
            //self.selfSlider.setThumbImage(circleImage , for: .normal)
            return circleImage!

    }


    @IBAction func runningRecord(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RecordViewController") as! RecordViewController
        self.navigationController?.pushViewController(controller, animated: false)

    }


}
extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/4, size.width/4)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
