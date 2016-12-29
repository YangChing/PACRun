//
//  StopViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 18/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import GoogleMaps
import Alamofire
import SwiftyJSON

class StopViewController: UIViewController {
    //======street view
    //Google map
    var panoView : GMSPanoramaView?
    //用來儲存heading方線的變數：單位是“度” 0~360
    var heading : Double = 0
    //用來儲存座標的變數
    var coordinateValue : CLLocationCoordinate2D?
    //==================================
    var isDistanceChange : Int = 0
    var myPoint : CLLocationCoordinate2D?
    var mylocation : GMSMarker?

    let waypoint = [["lat": 34.685805, "lng": 135.520839],
                    ["lat": 34.681447, "lng": 135.533316],
                    ["lat": 34.666009, "lng": 135.528898],
                    ["lat": 34.667120, "lng": 135.500377],
                    ["lat": 34.692524, "lng": 135.501049],
                    ["lat": 34.692847, "lng": 135.525379],
                    ["lat": 34.694361, "lng": 135.501093],
                    ["lat": 34.666946, "lng": 135.500048],
                    ["lat": 34.667551, "lng": 135.479776],
                    ["lat": 34.674991, "lng": 135.481133],
                    ["lat": 34.667551, "lng": 135.479776],
                    ["lat": 34.666946, "lng": 135.500048],
                    ["lat": 34.655325, "lng": 135.497787],
                    ["lat": 34.654449, "lng": 135.505484],
                    ["lat": 34.659037, "lng": 135.490179],
                    ["lat": 34.649553, "lng": 135.490243],
                    ["lat": 34.649389, "lng": 135.497482],
                    ["lat": 34.623359, "lng": 135.490346],
                    ["lat": 34.620749, "lng": 135.475964],
                    ["lat": 34.609081, "lng": 135.473201],
                    ["lat": 34.627606, "lng": 135.432100],
                    ["lat": 34.630179, "lng": 135.438037],
                    ["lat": 34.638693, "lng": 135.436335],
                    ["lat": 34.637278, "lng": 135.427844],
                    ["lat": 34.641450, "lng": 135.422025],
                    ["lat": 34.640108, "lng": 135.414006],
                    ["lat": 34.6380876, "lng": 135.4161057]]


    @IBOutlet weak var inStopStreetView: UIView!

    @IBOutlet weak var inStopMapView: UIView!

    @IBOutlet weak var mapViewButtonOutlet: UIButton!


    @IBOutlet weak var streetViewButtonOutlet: UIButton!
    
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
    //建立紀錄物件
    let runRecord : RunRecordManager? = nil
    //設定目標距離跟tempo
    var objectDistance : Int?
    var tempoSpeed : Int?
    //設定地圖
    var latitude:Double?
    var longitude:Double?
    var mapView : GMSMapView?
    var marker = GMSMarker()
    var virLatitude : String?
    var virLongitude : String?
    var virHeading : Double?
    //設定tempo

    @IBOutlet weak var tempoLabel: UILabel!


    let music = TempoManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.virLatitude = String(34.685805)
        self.virLongitude = String(135.520839)

        self.myPoint = CLLocationCoordinate2DMake(Double(self.virLatitude!)!,Double(self.virLongitude!)!)
        self.coordinateValue = self.myPoint
        //播放音樂=====
        if tempoSpeed == 0 {
            music.setRate = 0
        }else{
            music.setRate = Float(tempoSpeed!)/10 + 0.5
        }
        music.playSound()
        //=========
        tempoLabel.text = String(tempoSpeed!)
        //
        self.navigationItem.title = "跑步中"
        NotificationCenter.default.addObserver(self, selector: #selector(StopViewController.updateTimeLabel(date:)), name: NSNotification.Name("stopwatchTime"), object: nil)
        
        //print("OBD:\(objectDistance)")
        //設定跑者在虛擬地圖的位置
        self.latitude = 34.683298
        self.longitude = 135.52167
       // NotificationCenter.default.addObserver(self, selector: #selector(StreetViewController.didUpdateCoordinate(date:)), name: NSNotification.Name(rawValue: "updateCoordinate"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        //設定地圖的frame
        self.mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.inStopMapView.frame.width, height: self.inStopMapView.frame.height))

        self.inStopMapView.addSubview(mapView!)
        //加入跳到map的按鈕
        self.mapView?.addSubview(mapViewButtonOutlet)
        //關閉google map 的功能
        self.mapView?.settings.scrollGestures = false
        self.mapView?.settings.rotateGestures = false
        self.mapView?.settings.zoomGestures = false

        //標示起始點的位置
        let startPoint = CLLocationCoordinate2DMake(34.683298, 135.52167)
        let location1 = GMSMarker(position: startPoint)
        //location1.title = "London";
       // london1.icon = UIImage(named: "house")
        location1.map = mapView;
        //標示終點的位置
        let endPoint = CLLocationCoordinate2DMake(34.6380876, 135.4161057)
        let location2 = GMSMarker(position: endPoint)
        location2.map = mapView;

        //設定camera的位置
        let vancouver = CLLocationCoordinate2DMake(34.710298, 135.54067)
        let calgary = CLLocationCoordinate2DMake(34.6000876, 135.4001057)
        let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
        self.mapView?.camera = (mapView?.camera(for: bounds, insets: UIEdgeInsets.zero))!
        //self.mapView?.camera = GMSCameraPosition.camera(withLatitude: self.latitude!,longitude:self.longitude! , zoom: 13)
        //設定類型
        self.mapView?.mapType = kGMSTypeTerrain
        //
        //是否顯示自己的位置
        self.mapView?.isMyLocationEnabled = true

        //繪製路徑
        /*let draw = DrawRoute()
        draw.mapView = self.mapView
        for i in 0...25 {
            print("i=\(i)")
        draw.addOverlayToMapView(originLat: waypoint[i]["lat"]!, originLon: waypoint[i]["lng"]!, destinationLat: waypoint[i+1]["lat"]!, destinationLon: waypoint[i+1]["lng"]!)
        }*/
        let route = ["cqurEk|czXjGsA`BYJGfB_@HKzA}CtAwCHi@j@wMX}GHmB\\kC`@}CBwD@yPBoA`@?",
                     "_vtrE}jfzX\\?^OTB~ARv@LnC^XH@CdC^`ALdAPlEn@bDd@BDJBrAh@f@Vh@Rl@Zz@\\Pb@f@DFEDEBBHFnCh@BBPBfCj@rB`@BBNBhDt@HHNBDCp@RdDr@NHHAtA^BD^DdDv@BDR?r@NjAXxGxALBDF@A@BHLP?H??U?W",
                     "ouqrEsnezX?l@b@A@A?F@GIB?x@A~@FtA@PGdK?|JHHC\\E\\D`EWjGAj@?tE@p@NRLPEt@[JMFEd@OvB?RWlD@BARCFMdBM|A@BNZ?REv@ONGD?HG`EKrIEfEN\\BBCn@?LSRAj@EpCGtEGpFMfHBXCv@?HB??DS??P?h@K??z@AzAErICvL?`BS?",
                     "o|qrEs|_zXaB??e@G?B??Hk@A_A?qF?kB@mA?OC?B_C@UCKBaC?IMO?ILy@?aA?KEIAKFgCA?CK??DCAu@AuA?}A?Y?AKs@A_@AGLW@sA?CGO?AFgCCGEK?ADqCCGGK?EFkCGIEM?CD_CCCMS?KJyBEKEK?GBeCCwCCq@C_AAICc@@uACgCEKEm@?IBq@AwACyCGcDECEM?IF}BK[AgCCKGQ?OBkBCYCCBsBEQC_CASCGB_A?eAACEK?AD}CEwC??OF??H?RI??La@?",
                     "a{vrEo``zX?k@@c@F@JoALwADo@Fi@E?JwAHcAH}AJeFLsBHcAMAMC@IB@D@JkAOWLe@LEhCeKFWzAmCd@u@b@mADkFEYKE?i@LGDMJsH\\qFZuGECJsBDA@W@a@?[@}AFWDy@w@sCIYQe@wAeEa@}Ao@qBsAyDOQEO{AyE_BeFgAmDCI",
                     "s}vrEixdzXhAtDtDfLLh@NPFPtA|DfAxDlBrF|@dDMpA?dBAf@C^CDC@GrBBBCr@UlEc@lHGjGELMF?h@JDDPChFG\\a@`Aa@l@wAhCCFYhAwBnIMDMd@}BmAKR]hB_BnHDRSX]?a@NMV_@zCUbCAZYfGD`@a@AID?l@",
                     "agwrEy``zX?\\@Bn@@DCpCN\\@zAHFFLTDD`@ERWB?|C@lDBfA?bAADDRExBBVBtBBRBvB@JDT@HCd@@bBBV?~BDHBL?BCpCJT?|BFxCFPBl@?JCv@BlA@vABl@DrBAhEFnABHBTCxBBLPR?@O|BDDDRCpCBFDJ@DEnCBDFJ?DEdCB@DR@?G|@Bz@Br@AV?DCd@?zA?dB@hE?fCEFNRAHI~B?T?|C?fD?~C@|C@JAtA??HtA?",
                     "g_rrEq{{yXESUNeDh@iEl@s@Bo@CgBUgB[{Cu@eG{AqAc@sGmC",
                     "g_rrEq{{yXESlA[I_@CMGCe@qDSmB[oDYmCAg@IQQwBOeB@YAWMOQ{B]qC?GFICgB?IDaADgBFQTU?k@CEQ[TiFDO@UCIL{DJ_D`@kHBq@TcEDMD{@ZsCJ}@f@yE@IXHDc@HEEWOq@Da@Fg@NAB_@FqBBaG@c@",
                     "g{qrEcz_zXJKFI^@J?N?fA?jB?dB?Z^zAC?JVT`B|A~DzDn@D^j@~ADzEJpCDtBFhA?zCAxBAd@ELD~@?dAA~GAX?RK@DMH?HI??FP??P",
                     "srorEml_zX?QQ??GH??ILIAEDEh@yF~@gJCYFuAPQH{@K_BKO?UDQYkDCk@?kA`@oDGIBASc@?Qz@H",
                     "imorEk|`zX{@I?PRb@C@FHa@nD?jABj@XjDEP?TJNJ~AIz@QPGtABXYnCe@vEi@xFYP?jABF?JCn@{@~BkCpHYz@sAtAmExEWt@SdAmC~Ji@pB",
                     "kjprEy|}yXLe@n@@HLpFMVAHDtBAbEE|A@NA~FGBGZ@FDfA?@CJ?~A@jA?|AA~BF?d@FFH?fB?vE@@BR@",
                     "wnnrEo|}yXTC?o@G?BwE?I@iE@cCDmNDyCBuD",
                     "omsrEsd|yXtHzCn@TnD|@fCp@nDt@hC\\n@Br@CnJwATODR",
                     "yjirEu}}yXXtAr@nGzBpTvFtl@j@vFF|BL?",
                     "qmnrEqi_zXxDd@T@vDb@RBxALPSfCVjD\\bCV~BTrBRnDl@pHtAzJlBJULB`C`@tAXlEz@THh@HjEz@fDl@VFHCl@J@HlAVvAVL\\vB`@lDdArCt@bBh@pD|@xDhA`Cl@~Bl@|@TdBZfANlCf@fGz@vDl@",
                     "g{qrEcz_zXCbFClAE~AALAVO@MhAThAID?JEVYIQxAW~BIz@CNYnC?NKx@W~EYrFUhFMjD?RBHGd@UhFLTFJ?j@GFMLGPGvBCv@@P@xAGHHr@VxBLfBLN?p@TfCJtAHP@f@TrBFt@ZpDr@zF@DFBFXDRmAZDR",
                     "uzhrEqc{yXT@dC`A`K~DxHzChAd@fABpFPlIRPSh@@bPb@|@Bj@@JOFG@MDBCb@P@",
                     "efjrEkqryXu@eFGm@Y{@Dc@[eAi@kBYGa@oAa@_AWUq@w@_@}@gCyI",
                     "qujrEovsyXge@pFwGt@UO[B{BVQHIHAB",
                     "iqfrEkrzyXCl@CJAZ]bGQjCEn@D?G`@[|FStDAb@SdDQvCDTAf@KPEr@UZgAjSa@|HWrHm@xK_@vBw@hDiDzPwE~TeBpIKz@Gv@?pA?nA?fL?zAAtDqHpB?vHC`@AvH@fEoLjDGLe@LEXx@rCeAL@\\_@JKGm@R{@LeA`@}A`@EDw@VBHYFQI]LGV]HYH{@Hs@H_EjAkBh@IEIWUF@BCNM@ERGBDRIBwIdC_Cn@EBEUUDOGUJJVwErASN_@`@_B`@e@b@S^SiA",
                     "}jlrEclsyXAh@TfCTHp@rH\\zBnCzY^xEK@",
                     "cblrE}vqyXeEb@gCZa@LMJCb@UXu@nAgBlDcBdDoChFWt@In@?v@RtCRNBV",
                     "c{lrE{rpyXB\\IXr@xG`@dD\\xDfEvAGZJT}ChDHTJhABbBx@dJNLHZ",
                     "yrlrEaaoyXI[pI_JVe@"]
        for i in 0...25 {
        addPolyLineWithEncodedStringInMap(encodedString: route[i])
        }
        mylocation = GMSMarker(position: myPoint!)
        mylocation?.icon = UIImage(named: "New_location")
        mylocation?.map = mapView;

        //======Street View==========
        self.panoView = GMSPanoramaView(frame: CGRect(x: 0, y: 0, width: self.inStopStreetView.bounds.width, height: self.inStopStreetView.bounds.height))
        self.inStopStreetView.addSubview(panoView!)
        self.inStopStreetView.addSubview(streetViewButtonOutlet)
        panoView?.camera = GMSPanoramaCamera(heading: heading, pitch: -10, zoom: 1)
        if let coordinate = coordinateValue {
            panoView?.moveNearCoordinate(coordinate)
        }



    }
    @IBAction func pauseButton(_ sender: Any) {
        //Distance
        GPSManager.sharedInstance.isRecord = false
        GPSManager.sharedInstance.isPause = true
        //Time
        self.pause()
        self.startAndStopView.isHidden = false
        self.pauseButton.isHidden = true

        self.navigationItem.title = "暫停"
    }

    @IBAction func stopButton(_ sender: Any) {
        //distance
        GPSManager.sharedInstance.isRecord = false
        distanceLabel.text = "00.000"
        GPSManager.sharedInstance.startLocation = nil
        GPSManager.sharedInstance.traveledDistance = 0
        isDistanceChange = 0
        //time
        self.stop()
        //GPS
        GPSManager.sharedInstance.locationManager.stopUpdatingHeading()
        GPSManager.sharedInstance.locationManager.stopUpdatingLocation()

        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func playButton(_ sender: Any) {
        //distance
        GPSManager.sharedInstance.isRecord = true
        GPSManager.sharedInstance.isPause = false
        //time
        self.start()
        self.pauseButton.isHidden = false
        self.startAndStopView.isHidden = true

        self.navigationItem.title = "跑步中"
    }

    func updateTimeLabel(date:Notification) {
        if let dic = date.userInfo as? [String:String]{
            self.stopwatchLabel.text = dic["time"]
        }
    }
    //增加音樂速度
    @IBAction func tempoAddSpeed(_ sender: Any) {


        if tempoSpeed! <= 9  && tempoSpeed! >= 0{

            DispatchQueue.main.async {
                self.tempoLabel.text = String(Int(self.tempoSpeed!) + 1)
                self.tempoSpeed = self.tempoSpeed! + 1
                if self.tempoSpeed == 0 {
                    self.music.setRate = Float(self.tempoSpeed!) + 0.1

                }else{
                    self.music.setRate = (Float(self.tempoSpeed!))/10 + 0.5
                }
                self.music.playSound()
                //print("tempospeed\(self.tempoSpeed!)")
                //print("music.setRate\(self.music.setRate!)")
            }


        }
    }
    //降低音樂速度
    @IBAction func tempoSubstractSpeed(_ sender: Any) {

        if tempoSpeed! <= 10  && tempoSpeed! >= 1{

            DispatchQueue.main.async {
                self.tempoLabel.text = String(Int(self.tempoSpeed!) - 1)
                 self.tempoSpeed = self.tempoSpeed! - 1
                if self.tempoSpeed == 0 {
                   player?.stop()
                    self.music.setRate = 0.5
                }else{
                    self.music.setRate = (Float(self.tempoSpeed!))/10 + 0.5
                    self.music.playSound()
                }

            }

        }

    }


    @IBAction func mapButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "VirtualMapViewController") as! VirtualMapViewController
      
        controller.latitude =  Double(self.virLatitude!)
        controller.longitude =   Double(self.virLongitude!)

        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func streetViewButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "VirtualStreetViewController") as! VirtualStreetViewController

        controller.latitude =  Double(self.virLatitude!)
        controller.longitude =   Double(self.virLongitude!)
        controller.heading = virHeading!
        
        self.navigationController?.pushViewController(controller, animated: true)

    }



}
//計時器
extension StopViewController {

        func start(){
            if timer == nil { //Start Timer
                timer = Timer()
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StopViewController.updateTimer), userInfo: nil, repeats: true)
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
                //設定計時器的文字
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
            formater.dateFormat = "HH:mm:ss"
            formater.timeZone = NSTimeZone(name: "GMT") as TimeZone!
            var date = NSDate(timeIntervalSince1970: timeInterval)
            //紀錄座標
            if runRecord?.startLocation == nil {
                runRecord?.startLocation = GPSManager.sharedInstance.GPSCoordinate
            }
            runRecord?.allCoordinate?.append(GPSManager.sharedInstance.GPSCoordinate!)
            //顯示現在的路程
            distanceLabel.text = formatDistance(meters: GPSManager.sharedInstance.traveledDistance)
            
            ///////////////////
            return formater.string(from: date as Date)
    }
    //距離轉換，從GPS獲得的距離，轉換後只取到公尺，顯示單位為公里
    func formatDistance(meters: Double) -> String {

        let distance = Double(round(meters/10)/100)
        self.movePoint(distance: Int(meters))
        return String(distance)
    }
    //移動自己的點
    func movePoint(distance:Int){
        print("ooooooo\(objectDistance)")
        //判斷距離移動才去後台取點的位置
        if distance < objectDistance!*1000 {
            if distance - isDistanceChange >= 10  {
                Alamofire.request("https://i-running.ga/api/marathons/osaka/coordinates/\(Int(distance/10))").responseJSON { response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        //print("JSON: \(json)")
                        self.virLatitude = json["coordinate"]["latitude"].stringValue
                        self.virLongitude = json["coordinate"]["longitude"].stringValue
                        let pointCount = json["coordinate"]["point_count"].stringValue
                        self.mylocation?.map = nil
                        //print("virLongitude:\(self.virLongitude)")
                        self.myPoint = CLLocationCoordinate2D(latitude: Double(self.virLatitude!)!,longitude: Double(self.virLongitude!)!)
                        self.mylocation = GMSMarker(position: self.myPoint!)
                        self.mylocation?.icon = UIImage(named: "New_location")
                        self.mylocation?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        self.mylocation?.map = self.mapView
                        self.coordinateValue = self.myPoint
                        self.virHeading =  Double(json["coordinate"]["heading"].stringValue)
                        self.coordinateValue = self.myPoint
                        self.panoView?.camera = GMSPanoramaCamera(heading: self.virHeading!, pitch: -10, zoom: 1)
                        self.panoView?.moveNearCoordinate(self.coordinateValue!)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatePointCount"), object: nil, userInfo: ["point_count": pointCount ])

                    case .failure:
                        print("error")
                    }

                }
                //更新距離
                isDistanceChange = distance
            }
        }else{
            showFinishView()

        }
    }
    func addPolyLineWithEncodedStringInMap(encodedString: String) {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 4
        polyLine.strokeColor = UIColor.blue
        polyLine.map = mapView
    }
    func showFinishView(){
        let nib = UINib(nibName: "GoalView", bundle: nil)
        let array = nib.instantiate(withOwner: nil, options: nil)
        let goalView = array[0] as! UIView
       // let size = goalView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        goalView.frame = CGRect(origin: CGPoint(x: 0  , y: 64) , size: CGSize(width: 375, height: 201))
        self.view.addSubview(goalView)
        GPSManager.sharedInstance.locationManager.stopUpdatingHeading()
        GPSManager.sharedInstance.locationManager.stopUpdatingLocation()
    }
    
}
