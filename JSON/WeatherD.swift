//
//  WeatherD.swift
//  JSON
//
//  Created by Brian Advent on 11.05.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import Foundation

struct WeatherD {
//   let summary:String
//    let icon:String
     let temperature:Double
    let tempLow:Double
    let sunsetTime:Double
//    let windSpeed:Double
//    let humidity:Double
    let time:Double
//    let cloudCover: Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
 //       guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
//        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
//
         guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        guard let tempLow = json["temperatureLow"] as? Double else {throw SerializationError.missing("temp is missing")}
        guard let sunsetTime = json["sunsetTime"] as? Double else {throw SerializationError.missing("temp is missing")}
        
//        guard let windSpeed = json["windSpeed"] as? Double else {throw SerializationError.missing("temp is missing")}
//        guard let humidity = json["humidity"] as? Double else {throw SerializationError.missing("temp is missing")}
        guard let time = json["time"] as? Double else {throw SerializationError.missing("time is missing")}
//         guard let cloudCover = json["cloudCover"] as? Double else {throw SerializationError.missing("time is missing")}
        
 //       self.summary = summary
//        self.icon = icon
         self.temperature = temperature
         self.tempLow = tempLow
//        self.windSpeed = windSpeed
//        self.humidity = humidity
        self.time = time
        self.sunsetTime = sunsetTime
//        self.cloudCover = cloudCover
        
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/efd21cf614c4f0429e807683bbe7b1e4/"
    
    
    
    
    
    static func dailyForecast (withLocation location:String, completion: @escaping ([WeatherD]) -> ()) {
        
        let url = basePath + location
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[WeatherD] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                print("df",dailyForecasts)
                                for dataPoint in dailyData {
                                    let weatherObject = try? WeatherD(json: dataPoint)
                                    forecastArray.append(weatherObject!)
                                }
                            }
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
