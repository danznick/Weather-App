//
//  ViewController.swift
//  Weather
//
//  Created by Daniel Gomes on 22/11/2019.
//  Copyright © 2019 Daniel Gomes. All rights reserved.
//

//  Weather icons credit -- https://www.flaticon.com/icon-packs/weather%20pack/6

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation //user location library
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var location: UILabel!
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var conditionLabel: UILabel!
    
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var backroundView: UIView!
    
    @IBOutlet var currentConditions: UILabel!
    
    // MARK: - API Source: https://api.openweathermap.org/data/2.5/weather?q=London&appid=3a5aa8b29c472fc91e430147000649ab
    
    let apiKey = "3a5aa8b29c472fc91e430147000649ab"
    //** backup ** let apiKey = "2167c267478d591869e77b075cf3b569"
    var lat = 51.522922 //default value latitude, longitute, QM Engineering Building :)
    var lon = -0.041674
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicatorSize: CGFloat = 150
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .ballClipRotateMultiple, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.systemPink
        view.addSubview(activityIndicator)
        
        // MARK: - Location Services Manager
        
        locationManager.requestWhenInUseAuthorization()
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
            
        else {
            activityIndicator.stopAnimating()
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func btnPlanTripClick(_ sender: UIButton) {
        let weatherVC = WeatherViewController.shareInstance()
        self.navigationController?.pushViewController(weatherVC, animated: true)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        //"http://api.openweathermap.org/data/2.5/weather?lat=51.522922&lon=-0.041674&appid=3a5aa8b29c472fc91e430147000649ab&units=metric")
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                self.location.text = jsonResponse["name"].stringValue //displays location name
                self.conditionImageView.image = UIImage(named: iconName)   // s
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue )))" //rounded display temp
                self.currentConditions.text = " Today's conditions are expected to be  '" + jsonWeather["description"].stringValue + "' and expected low " +   "\(Int(round(jsonTemp["temp_min"].doubleValue)))"  + ", expected high " +   "\(Int(round(jsonTemp["temp_max"].doubleValue)))"
                
                let  date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from:date)
                
            }
        }
        
    }
}
