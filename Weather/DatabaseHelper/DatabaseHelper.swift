//
//  DatabaseHelper.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

//DB helper fetch

import UIKit
import CoreData
//database all functions -- db helper Singleton pattern 
class DatabaseHelper{
    static let shareInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // connects to Core Data
    var temp: Double = 0
    var lowTemp: Double = 0
    var highTemp: Double = 0
    
    func saveinventory(modelClothe: InventoryModel, weather: Weather){ //
        let inventory = Inventory(context: context)
        inventory.name = modelClothe.name
        inventory.price = modelClothe.price
        inventory.category = modelClothe.category
        inventory.cloValue = modelClothe.cloValue
        inventory.imgPath = modelClothe.imgPath
        inventory.feature = modelClothe.feature
        inventory.type = modelClothe.type
        inventory.isGear = modelClothe.isGear
        inventory.weight = modelClothe.weight
        inventory.weather = weather
        save()
    }
    
    func getAllInventories() -> [Inventory]{
        var arrInventories = [Inventory]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Inventory")
        do{
            let fetchArr = try context.fetch(fetchRequest) as? [Inventory]
            if fetchArr != nil{
                arrInventories.append(contentsOf: fetchArr!)
            }
        }catch let err{
            print(err.localizedDescription)
        }
        return arrInventories
    }
    
    func saveWeather(location: String){
        let weather = Weather(context: context)
        weather.location = location
        save()
    }
    
    func getWeather(location: String) -> Weather?{
        var modelWeather: Weather?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        
        do{
            let fetchArr = try context.fetch(fetchRequest) as? [Weather]
            if fetchArr != nil{
                let arr = fetchArr?.filter{ $0.location == location }
                if arr?.count ?? 0 > 0{
                    modelWeather = (arr?.first)!
                }
            }
        }catch let err{
            print(err.localizedDescription)
        }
        return modelWeather
    }
    
    func saveTrip(name: String, weather: Weather){  //
        let trip = Trip(context: context)
        trip.name = name
        trip.weather = weather
        save()
    }
    
    func saveTripWithInventory(trip: Trip, inventory: Inventory){
        do{
            if let tripInstance = try context.existingObject(with: trip.objectID) as? Trip{ //sets "Trips" by autoId
                tripInstance.addToInventories(inventory)
            }
            save()
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
    
    func getAllTrip() -> [Trip]{
        var arrTrip = [Trip]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        do{
            let fetchArr = try context.fetch(fetchRequest) as? [Trip]
            if fetchArr != nil{
                arrTrip.append(contentsOf: fetchArr!)
            }
        }catch let err{
            print(err.localizedDescription)
        }
        return arrTrip
    }
    
    func save(){
        do{
            try context.save()
        }catch let err{
            print(err.localizedDescription)
        }
    }
}
