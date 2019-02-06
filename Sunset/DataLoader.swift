//
//  DataLoader.swift
//  Sunset
//
//  Created by Dmytro Dobrovolskyy on 2/6/19.
//  Copyright © 2019 YellowLeaf. All rights reserved.
//

import Alamofire
import SwiftyJSON

class DataLoader {
    
    private static var manager = DataLoader().generateManager()
    
    private func generateManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Accept": "application/json",
                                               "Content-Type": "application/json"]
        let manager = Alamofire.SessionManager(configuration: configuration)
        
        return manager
    }
    
    func getPlacesInRadius(latitude: String, longitude: String, completion: @escaping (_ result: [String: String]) -> Void) {
        DataLoader.manager.request(Router.getSunset(
            latitude: latitude,
            longitude: longitude)).debugLog().validate().responseJSON { response in
            
            var sunsetInfo = [String: String]()
            let json = JSON(response.result.value as Any)
            
            for (key, value): (String, JSON) in json["results"] {
                if key == "sunrise" {
                    sunsetInfo["sunrise"] = value.stringValue
                } else if key == "sunset" {
                    sunsetInfo["sunset"] = value.stringValue
                }
            }
            
            completion(sunsetInfo)
        }
    }
    
}
