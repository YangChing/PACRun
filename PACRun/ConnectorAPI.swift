//
//  ConnectorAPI.swift
//  PACRun
//
//  Created by 馮仰靚 on 25/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import Foundation
import Alamofire

class ConnectorAPI{

    func getAllMarathons(){

        Alamofire.request("https://i-running.ga/api/marathons").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
    }
    func getMarathons(id:Int){
        Alamofire.request("https://i-running.ga/api/marathons/\(id)").responseJSON { response in


            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }

    }
    func postMarathons(parameters:Parameters){
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    func getCoordinate(id:Int){
        Alamofire.request("https://i-running.ga/api/marathons/osaka/coordinates/\(id)").responseJSON { response in

            if let JSON = response.result.value {
                print("JSON: \(JSON)")

            }

        }
    }

    
}
