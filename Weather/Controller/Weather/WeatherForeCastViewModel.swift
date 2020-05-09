//
//  WeatherForeCastViewModel.swift
//  Weather
//
//  Created by Daniel Gomes on 25/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit
import Alamofire

class WeatherForeCastViewModel{
    
    func getWeatherForeCastData(locationName: String, completionHandler: @escaping ((WeatherLocationModel) -> ())){
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?q=\(locationName)&appid=3a5aa8b29c472fc91e430147000649ab").response { //
            response in
            if response.error == nil{
                do{
                    if let data = response.data{
                        let jsonResponse = try JSONDecoder().decode(WeatherLocationModel.self, from: data)
                        completionHandler(jsonResponse.self)
                    }
                }catch let err{
                    print(err.localizedDescription)
                }
            }else{
                print(response.error?.localizedDescription)
            }
        }
    }
}
