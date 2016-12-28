//
//  DrawRoute.swift
//  PACRun
//
//  Created by 馮仰靚 on 27/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON
import GoogleMaps
import GooglePlaces

class DrawRoute{

    var mapView:GMSMapView?
    func addOverlayToMapView(originLat:Double,originLon:Double,destinationLat:Double,destinationLon:Double){
        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originLat),\(originLon)&destination=\(destinationLat),\(destinationLon)&mode=walking"
        let url = URL(string: directionURL)
        Alamofire.request(url!).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                //print(json)
                let errornum = json["error"]
                if (errornum == true){
                }else{
                    let routes = json["routes"].array

                    if routes != nil{
                        let overViewPolyLine = routes![0]["overview_polyline"]["points"].string
                        //print("ooooo:\(overViewPolyLine)")
                        if overViewPolyLine != nil{
                            self.addPolyLineWithEncodedStringInMap(encodedString: overViewPolyLine!)
                        }
                    }
                }

            case .failure(let error):

                print("Request failed with error: \(error)")

            }
        }

    }
    func addPolyLineWithEncodedStringInMap(encodedString: String) {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 4
        polyLine.strokeColor = UIColor.blue
        polyLine.map = mapView
    }
    
    
}
