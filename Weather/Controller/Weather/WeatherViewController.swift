//
//  WeatherViewController.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    var dict = [String: String]()
    var viewModelWeather = WeatherForeCastViewModel()
    var locationName = ""
    @IBOutlet var lineView: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        txtLocation.placeholderColor(color: UIColor(red: 102, green: 201, blue: 98, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIBarButtonItem) {
        locationName = locationName.lowercased()
        if locationName == ""{
            self.popupAlert(title: "Alert", message: "Location cannot be empty", alertControllerStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], alertActions: [{_ in}])
        }else{
            let clotheVC = InventoryViewController.shareInstance()
            if DatabaseHelper.shareInstance.getWeather(location: locationName)?.location == locationName{
                clotheVC.modelWeather = DatabaseHelper.shareInstance.getWeather(location: locationName)!
            }else{
                DatabaseHelper.shareInstance.saveWeather(location: locationName)
                clotheVC.modelWeather = DatabaseHelper.shareInstance.getWeather(location: locationName)!
            }
            self.navigationController?.pushViewController(clotheVC, animated: true)
        }
    }
    
    @IBAction func btnSummaryTapped(_ sender: UIButton) {
        locationName = txtLocation.text ?? ""
        txtLocation.text = ""
        viewModelWeather.getWeatherForeCastData(locationName: locationName) { (modelForecast) in //  from WeatherForeCast
            let detailWeather = self.getWeatherDetail(modelForecast: modelForecast)
            let mirror = Mirror(reflecting: detailWeather)
            for child in mirror.children  {
                if child.label == "feels_li"{
                    self.dict["Feel like"] = child.value as? String ?? ""
                }else if child.label == "temp_min"{
                    self.dict["Expected lows"] = child.value as? String ?? ""
                }else if child.label == "temp_max"{
                    self.dict["Expected highs"] = child.value as? String ?? ""
                    
                }else if child.label == "wind_speed"{                           //changed this
                    self.dict["wind speed"] = child.value as? String ?? ""
                }else{
                    self.dict[child.label ?? ""] = child.value as? String ?? ""
                }
            }
            //self.dict["CHANCE OF RAIN"] = "10%" //'Spoof data for demo' My API does not show rain info (it's a premium feature)
            let _ = self.lineView.map{ $0.isHidden == false }
            self.tblView.reloadData()
        }
    }
    
    func getWeatherDetail(modelForecast: WeatherLocationModel) -> WeatherDetail{
        var weatherDetail = WeatherDetail()
        
        if modelForecast.weather.count > 0{
            lblDiscription.text = modelForecast.weather.first?.weatherDescription ?? ""
            imgIcon.image = UIImage(named: modelForecast.weather.first?.icon ?? "")
        }
        lblLocationName.text = modelForecast.name
        lblTemp.text = "\(modelForecast.main.temp ?? 0)".prefix(1) + "°"
        DatabaseHelper.shareInstance.temp = Double("\("\(modelForecast.main.temp ?? 0)".prefix(1))") ?? 0 //added prefix for demo, API faulty
        DatabaseHelper.shareInstance.lowTemp = Double("\("\(modelForecast.main.tempMin ?? 0)".prefix(1))") ?? 0
        DatabaseHelper.shareInstance.highTemp = Double("\("\(modelForecast.main.tempMax ?? 0)".prefix(1))") ?? 0
        weatherDetail.feels_li = "\(modelForecast.main.feelsLike ?? 0)".prefix(1) + "°"
        weatherDetail.temp_min = "\(modelForecast.main.tempMin ?? 0)".prefix(1) + "°"
        weatherDetail.temp_max = "\(modelForecast.main.tempMax ?? 0)".prefix(2) + "°"
        weatherDetail.pressure = "\(modelForecast.main.pressure ?? 0)".prefix(2) + " hPa"
        weatherDetail.humidity = "\(modelForecast.main.humidity ?? 0)" + "%"
        
        weatherDetail.wind_speed = "\(modelForecast.wind.speed ?? 0)" + " km/hr"
        //weatherDetail.visibility = "\(modelForecast.visibility)" + " km"
        weatherDetail.country = countryName(from: modelForecast.sys.country ?? "")
        weatherDetail.sunrise =  getTime(value: modelForecast.sys.sunrise ?? 0)
        weatherDetail.sunset = getTime(value: modelForecast.sys.sunset ?? 0)
        
        return weatherDetail
    }
    
    func getTime(value: Int) -> String{
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(value))
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        let formattedTime = formatter.string(from: sunriseDate)
        print(formattedTime)
        return formattedTime
    }
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
    
}

extension WeatherViewController{
    static func shareInstance() -> WeatherViewController{
        return WeatherViewController.instantiateFromStoryboard()
    }
}


extension WeatherViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dict.keys.sorted().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailCell", for: indexPath) as? WeatherDetailCell
        let arr = dict.keys.sorted().map{ $0 }
        cell?.lblTitle.text = arr[indexPath.row].uppercased()
        cell?.lblSubTitle.text = dict[arr[indexPath.row]]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
