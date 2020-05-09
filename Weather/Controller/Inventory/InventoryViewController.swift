//
//  ClotheViewController.swift
//  Weather
//
//  Created by Daniel Gomes on 10/04/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController {
    
    @IBOutlet weak var clotheTblView: UITableView!
    var arrClothes = [Inventory]()
    var modelWeather: Weather?
    var modelTrip: Trip?
    var indexOfTrip = 0
    
    @IBOutlet weak var btnTrips: UIBarButtonItem!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var lblCloValue: UILabel!
    @IBOutlet weak var filterSeg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clotheTblView.tableFooterView = UIView()
        filterSeg.selectedSegmentIndex = 0
        clotheTblView.register(UINib(nibName: "InventoryCell", bundle: nil), forCellReuseIdentifier: "InventoryCell")
        setupData()
        getCloValue()
    }
    
    func setupData(){
        if modelTrip == nil{
            //            if let clotheArr = modelWeather?.clothes?.allObjects as? [Clothe]{
            //                arrClothes.append(contentsOf: clotheArr)
            //            }
            self.title = "Inventory"
            arrClothes = DatabaseHelper.shareInstance.getAllInventories()
            btnTrips.title = "Activity"
            btnAdd.title = "Add + "
        }else{
            if let clotheArr = modelTrip?.inventories?.allObjects as? [Inventory]{
                arrClothes.append(contentsOf: clotheArr)
            }
            self.title = "Activity Inventory"
            btnTrips.title = ""
            btnAdd.title = ""
        }
        clotheTblView.reloadData()
    }
    
    func filterGearData(){
        if modelTrip == nil{
            //            if let clotheArr = modelWeather?.clothes?.allObjects as? [Clothe]{
            //                let clothes = clotheArr.filter{ $0.isWater == true }
            //                arrClothes.append(contentsOf: clothes)
            //            }
            arrClothes = DatabaseHelper.shareInstance.getAllInventories().filter{ $0.isGear == true }
            btnTrips.title = "Activity"
            
        }else{
            if let clotheArr = modelTrip?.inventories?.allObjects as? [Inventory]{
                let clothes = clotheArr.filter{ $0.isGear == true }
                arrClothes.append(contentsOf: clothes)
            }
            btnTrips.title = ""
            btnAdd.title = ""
        }
    }
    func getCloValue(){
        if arrClothes.count > 0{
            let cloValue = arrClothes.map{ Float($0.cloValue ?? "0")! }.reduce(0, +)
            let weightValue = arrClothes.map{ Float($0.weight ?? "0")! }.reduce(0, +) // add guard
            lblCloValue.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
            
            if modelTrip == nil{
                lblCloValue.text = "Total  \(weightValue/1000) kg: " //clo: \(cloValue)
                
            }else{
                let fTemp = ((DatabaseHelper.shareInstance.temp * 9/5) + 32)
                let lowtemp = DatabaseHelper.shareInstance.lowTemp
                let hightemp = DatabaseHelper.shareInstance.highTemp
                if indexOfTrip == 1{
                    let requiredCloValue = String(format: "%.2f",  -2/45 * (fTemp) + 4.2)
                    
                    if requiredCloValue == "0.00"{
                        let dtemp = String(format: "%.2f",  -2/45 * 45 + 4.2) //guard for crash,  default temp
                        lblCloValue.text = "Total \(weightValue/1000) kg, clo: \(String(format: "%.2f", cloValue)) \n  Recommended clo\(dtemp) \n Lows: \(lowtemp) and Highs: \(hightemp)"
                    }else{
                        lblCloValue.text = "Total \(weightValue/1000) kg, current clo: \(String(format: "%.2f", cloValue)) \n  Recommended clo based on temp \(DatabaseHelper.shareInstance.temp) °C, is \(requiredCloValue) clo \n Lows: \(lowtemp) and Highs: \(hightemp)"
                    }
                }
                else if indexOfTrip == 2{
                    let requiredCloValue = String(format: "%.2f", -0.60/45 * (fTemp) + 1.1)
                    if requiredCloValue == "0.00"{
                        let temp = String(format: "%.2f",  -0.60/45 * 45 + 1.1)
                        lblCloValue.text = "Total \(weightValue/1000)  kg: clo:  \(String(format: "%.2f", cloValue)) \n  Recommended clo\(temp) \n Lows: \(lowtemp) and Highs: \(hightemp)"
                    }else{
                        lblCloValue.text = "Total \(weightValue/1000)  kg, current clo:  \(String(format: "%.2f", cloValue)) \n  Recommended clo \(requiredCloValue) \n Lows: \(lowtemp) and Highs: \(hightemp)"
                    }
                }
                
                
                /*else{
                 
                 // Third activity for demo purpose
                 let requiredCloValue = String(format: "%.2f",  -2/45 * (fTemp) + 4.2)
                 if requiredCloValue == "0.00"{
                 let temp = String(format: "%.2f",  -2/45 * 45 + 4.2)
                 lblCloValue.text = "Total \(weightValue/1000)  kg: clo:  \(cloValue) Recommended clo\(temp) "
                 }else{
                 lblCloValue.text = "Total \(weightValue/1000)  kg: clo:  \(cloValue) Recommended clo\(requiredCloValue) "
                 }
                 
                 }*/
            }
        }else{
            
            lblCloValue.text = "Total 0 KG : iclo: 0"
            lblCloValue.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        }
    }
    
    @IBAction func filterSegClick(_ sender: UISegmentedControl) {
        arrClothes.removeAll()
        if sender.selectedSegmentIndex == 0{
            setupData()
        }else{
            filterGearData()
        }
        getCloValue()
        clotheTblView.reloadData()
    }
    
    @IBAction func btnClotheAddClick(_ sender: UIBarButtonItem) {
        let addClotheVC = AddInventoryViewController.shareInstance()
        addClotheVC.delegate = self
        addClotheVC.modelWeather = modelWeather
        self.navigationController?.pushViewController(addClotheVC, animated: true)
    }
    
    @IBAction func btnTripsClick(_ sender: UIBarButtonItem) {
        if modelTrip == nil{
            let tripVC = TripViewController.shareInstance()
            tripVC.modelWeather = modelWeather
            tripVC.isFromSelection = false
            self.navigationController?.pushViewController(tripVC, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // @IBAction func btnSettingTapped(_ sender: UIBarButtonItem) { ///removed
    // let settingVC = SettingViewController.shareInstance()
    //
    // }
    
}

extension InventoryViewController{
    static func shareInstance() -> InventoryViewController{
        return InventoryViewController.instantiateFromStoryboard()
    }
}

extension InventoryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrClothes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as? InventoryCell else {  return InventoryCell()}
        cell.modelClother = arrClothes[indexPath.row]
        return cell
    }
}

extension InventoryViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if modelTrip == nil{
            let tripVC = TripViewController.shareInstance()
            tripVC.modelClothe = arrClothes[indexPath.row]
            tripVC.modelWeather = modelWeather
            tripVC.isFromSelection = true
            self.navigationController?.pushViewController(tripVC, animated: true)
        }
    }
}

extension InventoryViewController: ClotheData{
    func refresh() {
        arrClothes.removeAll()
        setupData()
        getCloValue()
    }
}
