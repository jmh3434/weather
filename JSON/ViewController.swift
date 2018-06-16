//
//  ViewController.swift
//  JSON
//
//  Created by Brian Advent on 11.05.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    let container = UIView()
    let redSquare = UIView()
    let blueSquare = UIView()
    
    var label = UILabel()
    var labeld = UILabel()
    var labelSum = UILabel()
    var labelHigh = UILabel()
    var labelLow = UILabel()
    
    var refreshButton = UIButton()
    
    
    
    var resultSummary = String()
    typealias FinishedDownload = () -> ()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        
        // <!--
        self.container.frame = CGRect(x: 60, y: 60, width: 200, height: 200)
        self.view.addSubview(container)
        
   
        self.redSquare.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.blueSquare.frame = redSquare.frame
            
        
        self.blueSquare.backgroundColor = UIColor.blue
       
        let fish = UIImageView()
        fish.image = UIImage(named: "icon_weather.png")
        fish.frame = CGRect(x: 180, y: 160, width: 100, height: 100)
        self.redSquare.addSubview(fish)
        
        
        
        
        self.container.addSubview(self.redSquare)
        UIView.animate(withDuration: 1.5, animations: {
        self.redSquare.frame.origin.y -= 160
        }, completion: nil)
    
        getTheSearchLocationAndRange()
        // label for CH
        let labelch = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        labelch.numberOfLines = 5
        labelch.text = "Chapel Hill Weather"
        labelch.center = CGPoint(x: 130, y: 118)
        labelch.textAlignment = .justified
        labelch.textColor = UIColor.black
        labelch.font = UIFont(name: "Dosis-Bold", size: 35)
        self.view.addSubview(labelch)
        
        //label for time, windspeed, and humidity
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        label.numberOfLines = 112
        label.center = CGPoint(x: 180, y: 250)
        label.textAlignment = .natural
        label.textColor = UIColor.black
        label.font = UIFont(name: "Dosis-Light", size: 26)
        self.view.addSubview(label)
        
        // label for low temp
        labelLow = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        labelLow.numberOfLines = 112
        labelLow.center = CGPoint(x: 180, y: 450)
        labelLow.textAlignment = .center
        labelLow.textColor = UIColor.blue
        labelLow.font = UIFont(name: "Dosis-Light", size: 30)
        self.view.addSubview(labelLow)
        
        
        //label for current temp
        labeld = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        labeld.numberOfLines = 112
        labeld.center = CGPoint(x: 180, y: 480)
        labeld.textAlignment = .center
        labeld.textColor = UIColor.black
        labeld.font = UIFont(name: "Dosis-Light", size: 30)
        self.view.addSubview(labeld)
        
        // label for max temp
        labelHigh = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        labelHigh.numberOfLines = 112
        labelHigh.center = CGPoint(x: 180, y: 510)
        labelHigh.textAlignment = .center
        labelHigh.textColor = UIColor.red
        labelHigh.font = UIFont(name: "Dosis-Light", size: 30)
        self.view.addSubview(labelHigh)
        
        
        
        // label for weather summary this week
        
        labelSum = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        labelSum.numberOfLines = 112
        labelSum.center = CGPoint(x: 180, y: 650)
        labelSum.textAlignment = .center
        labelSum.textColor = UIColor.black
        labelSum.font = UIFont(name: "Dosis-Light", size: 30)
        self.view.addSubview(labelSum)
        
        // buttton
        
        let button = UIButton(frame: CGRect(x: 150, y: 740, width: 80, height: 30))
        button.backgroundColor = .black
        button.setTitle("refresh", for: UIControlState.normal)
       // button.addTarget(self, action: #selector(JustPCAction), forControlEvents: .TouchUpInside)
        button.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(button)
        
        
        
    
        
    }
    @objc func buttonAction(sender: UIButton!) {
        getTheSearchLocationAndRange()
    }
   
    
    func getTheSearchLocationAndRange() {
        Weather.forecast(withLocation: "35.9467,-79.0612") { (results:[Weather]) in
            for result in results {

                DispatchQueue.main.async {
                    let windSpeed = String(result.windSpeed)
                    let nearestStormDistance = String(result.nearestStormDistance)
                    let cloudCover = String(result.cloudCover*100)
                    
                    let humidity = String(Int(result.humidity*100))
                    
                    let unixTimestamp = result.time
                    let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "EDT") //Set timezone that you want
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "MM-dd HH:mm" //Specify your format that you want
                    let strDate = dateFormatter.string(from: date)
                    
                    
                    
                    
                   
                    let temperature = String(result.temperature)
                    print("temperature",temperature)
                    self.labeld.text = temperature + "˚F"
                    self.labeld.textColor = UIColor.darkGray
                    
                    self.label.text = ("time: "+strDate+"\nwindspeed: "+windSpeed+" MPH. "+"\nhumidity: "+humidity+"%\nnearest storm: "+nearestStormDistance+" miles"+"\ncloud cover: "+cloudCover+"%")
                    
                
                    
                }
                
            }
            
        }
        
        
        
        WeatherSummary.forecast(withLocation: "35.9467,-79.0612") { (results:[WeatherSummary]) in
            for result in results {
                DispatchQueue.main.async {
                    let weatherSum = result.summary
                    self.labelSum.text = weatherSum
                    
                    
                }
              break
            }
        }
        WeatherD.dailyForecast(withLocation: "35.9467,-79.0612") { (results:[WeatherD]) in
            for result in results {
                DispatchQueue.main.async {
                    let tempHigh = String(result.temperature)
                    self.labelHigh.text = tempHigh + "˚F"
                    
                    let tempLow = String(result.tempLow)
                    self.labelLow.text = tempLow + "˚F"
                    
                    let unixTimestamp = result.time
                    let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "EDT") //Set timezone that you want
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "MM-dd HH:mm" //Specify your format that you want
                    let strDate = dateFormatter.string(from: date)
                    
                    
                    
                    print("time df ",strDate)
                    
                    
                }
                break
            }
        }
    }
   
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


