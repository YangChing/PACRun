//
//  VirtualMapViewController.swift
//  PACRun
//
//  Created by 馮仰靚 on 28/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import GoogleMaps
import Alamofire
import SwiftyJSON

class VirtualMapViewController: UIViewController  {

    var oldDistance:Int = 0

    @IBOutlet weak var inVirtualMapStreetView: UIView!

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

    var isDistanceChange : Int = 0
    var myPoint : CLLocationCoordinate2D?
    var mylocation : GMSMarker?
    var distance : Double?

    //設定地圖所需的變數
    var latitude:Double?
    var longitude:Double?
    var mapView : GMSMapView?
    var marker = GMSMarker()

    override func viewDidLoad() {
        super.viewDidLoad()

        myPoint = CLLocationCoordinate2DMake(self.latitude!, self.longitude!)
        NotificationCenter.default.addObserver(self, selector: #selector(VirtualMapViewController.movePoint(date:)), name: NSNotification.Name(rawValue: "updatePointCount"), object: nil)

        self.mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))

        self.view.addSubview(mapView!)
        mapView?.delegate = self
        //關閉google map 的功能
        //self.mapView?.settings.scrollGestures = false
        //self.mapView?.settings.rotateGestures = false
        //self.mapView?.settings.zoomGestures = false

        //標示起始點的位置
        let startPoint = CLLocationCoordinate2DMake(34.685585, 135.520828)
        let location1 = GMSMarker(position: startPoint)
         location1.userData = startPoint
        //location1.title = "London";
        // london1.icon = UIImage(named: "house")
        location1.map = mapView;
        //標示終點的位置
        let endPoint = CLLocationCoordinate2DMake(34.6380876, 135.4161057)
        let location2 = GMSMarker(position: endPoint)
        location2.userData = endPoint
        location2.icon = UIImage(named: "Destination")
        location2.map = mapView;

        //設定camera的可視範圍
        let vancouver = CLLocationCoordinate2DMake(34.680298, 135.54067)
        let calgary = CLLocationCoordinate2DMake(34.6300876, 135.4001057)
        let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
        self.mapView?.camera = (mapView?.camera(for: bounds, insets: UIEdgeInsets.zero))!
        //self.mapView?.camera = GMSCameraPosition.camera(withLatitude: self.latitude!,longitude:self.longitude! , zoom: 13)
        //設定類型
        self.mapView?.mapType = kGMSTypeTerrain
        //
        //是否顯示自己的位置
        //self.mapView?.isMyLocationEnabled = true

        //繪製路徑
        /*
         let draw = DrawRoute()
         draw.mapView = self.mapView
         for i in 0...25 {
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
        mylocation?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        mylocation?.userData = myPoint
        mylocation?.map = mapView

        self.view.addSubview(inVirtualMapStreetView)
        inVirtualMapStreetView.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        print("\(distance)")
        if (Int(distance!) + oldDistance) >= 2 {
            for i in 1...(Int(distance!) + Int(Double(oldDistance)/1.5)){
                if i < 448/15 {
                Alamofire.request("https://i-running.ga/api/marathons/osaka/coordinates/\(i*15)").responseJSON { response in
                    switch response.result{
                    case .success:
                        let json = JSON(response.result.value)
                        //print("JSON: \(json)")
                        let virLatitude = json["coordinate"]["latitude"].stringValue
                        let virLongitude = json["coordinate"]["longitude"].stringValue
                        let pointCount = json["coordinate"]["point_count"].stringValue

                        self.myPoint = CLLocationCoordinate2D(latitude: Double(virLatitude)!,longitude: Double(virLongitude)!)

                        let endPoint = CLLocationCoordinate2DMake(Double(virLatitude)!, Double(virLongitude)!)

                        let location2 = GMSMarker(position: endPoint)

                        location2.icon = UIImage(named: "Check_point")
                        location2.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        location2.userData = self.myPoint
                        location2.map = self.mapView

                    case .failure:
                        print("error")
                        }
                    }
                }
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func movePoint(date:NSNotification){

        print("\(date.userInfo!)")

        if let dic = date.userInfo! as? Dictionary{
            //重新設定google camera的位置

            let pointCount = dic["point_count"] as? String
            let lat = dic["latitude"] as? String
            let long = dic["longitude"] as? String
            //判斷距離移動才去後台取點的位置
            print("\(lat)")
            let virLatitude = lat
            let virLongitude = long
             self.mylocation?.map = nil
            self.myPoint = CLLocationCoordinate2D(latitude: Double(virLatitude!)!,longitude: Double(virLongitude!)!)
            self.mylocation = GMSMarker(position: self.myPoint!)
            self.mylocation?.icon = UIImage(named: "New_location")
            self.mylocation?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            self.mylocation?.userData = myPoint
            self.mylocation?.map = self.mapView



        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func addPolyLineWithEncodedStringInMap(encodedString: String) {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 4
        polyLine.strokeColor = UIColor.blue
        polyLine.map = mapView
    }
}
extension VirtualMapViewController : GMSMapViewDelegate{
    //handle when user tapped the marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //present information page
        //mapViewButtonMenuView.alpha = 0


        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "VirtualStreetViewController") as! VirtualStreetViewController

        let coor = marker.userData as! CLLocationCoordinate2D
        controller.latitude =  Double(coor.latitude)
        controller.longitude =   Double(coor.longitude)
        controller.heading = 0

        self.navigationController?.pushViewController(controller, animated: true)

        //change mark to red
        //if userData is nil -> is not court -> it's the searchresult
//        print("tap")
//        let panoView = GMSPanoramaView(frame: CGRect(x: 0, y: 0 , width:  inVirtualMapStreetView.frame.width, height: inVirtualMapStreetView.frame.height))
//        panoView.moveNearCoordinate(marker.userData as! CLLocationCoordinate2D)
//        self.inVirtualMapStreetView.addSubview(panoView)
//        inVirtualMapStreetView.isHidden = false

        return true
    }
}
