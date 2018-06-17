//
//  Weather.swift
//  JSON
//
//  Created by Brian Advent on 11.05.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import Foundation

struct Weather {
    let summary:String
    let icon:String
    let temperature:Double
    let windSpeed:Double
    let humidity:Double
    let time:Double
    let nearestStormDistance:Double
    let cloudCover:Double
    let precipProbability:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}

        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}

        guard let temperature = json["temperature"] as? Double else {throw SerializationError.missing("temp is missing")}
        guard let windSpeed = json["windSpeed"] as? Double else {throw SerializationError.missing("temp is missing")}
        guard let humidity = json["humidity"] as? Double else {throw SerializationError.missing("temp is missing")}
        guard let time = json["time"] as? Double else {throw SerializationError.missing("time is missing")}
        guard let nearestStormDistance = json["nearestStormDistance"] as? Double else {throw SerializationError.missing("time is missing")}
        guard let cloudCover = json["cloudCover"] as? Double else {throw SerializationError.missing("time is missing")}
        guard let precipProbability = json["precipProbability"] as? Double else {throw SerializationError.missing("time is missing")}
        
        
       

        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.time = time
        self.nearestStormDistance = nearestStormDistance
        self.cloudCover = cloudCover
        self.precipProbability = precipProbability
        
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/efd21cf614c4f0429e807683bbe7b1e4/"
    
    
    
    static func forecast (withLocation location:String, completion: @escaping ([Weather]) -> ()) {
        
        let url = basePath + location
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["currently"] as? [String:Any] {
                            
                        
                                    let weatherObject = try? Weather(json: dailyForecasts)
                                    forecastArray.append(weatherObject!)
                            
                                    
                            
                        }
                    
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()
        
        
        
        
        
        
        
        
    
    }
    

}
