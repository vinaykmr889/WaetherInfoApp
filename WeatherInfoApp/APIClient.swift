//
//  APIClient.swift
//  WeatherInfo
//
//  Created by Vinay Kumar on 21/11/19.
//  Copyright © 2019 Vinay Kumar. All rights reserved.
//

import Foundation

class APIClient: NSObject {
    
    let basePath = "http://api.openweathermap.org/"
    let APIKey = "0205f1732e3489f47e995f100ce33860"
    
    func forecast (withLocation location:String, completion: @escaping (MoreComplexStruct?) -> ()) {
        
        let url = self.basePath + "data/2.5/weather?q=\(location)" + "\("&APPID=\(APIKey)")"
        if URL(string: url) != nil{
            let request = URLRequest(url: URL(string: url)!)
            
            let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                
                if let data = data {
                    
                    do {
                        _ = try WeatherDetails(json: data, completion: { (results: MoreComplexStruct?) in
                            completion(results)
                        })
                    }catch {
                        completion(nil)
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
}
