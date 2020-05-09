//
//  TripViewController.swift
//  Weather
//
//  Created by Daniel Gomes on 24/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit

class TripViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var modelWeather: Weather?
    var isFromSelection = false
    var modelClothe: Inventory?
    var arrTrip = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getAllData()
        
    }
    
    func getAllData(){
        arrTrip.removeAll()
        if let allTrips = modelWeather?.trips?.allObjects as? [Trip]{
            arrTrip.append(contentsOf: allTrips)
            arrTrip.sort{
                $0.name ?? "" < $1.name ?? ""
            }
        }
    }
    
    @IBAction func btnAddTripClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Activity", message: "", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) { (saveTarget) in
            if let name = alert.textFields?.first?.text{
                DatabaseHelper.shareInstance.saveTrip(name: name, weather: self.modelWeather!)
                self.getAllData()
                self.tblView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        alert.addTextField { (txt) in
            txt.placeholder = "Enter Text"
        }
        self.navigationController?.present(alert, animated: true)
    }
    
}

extension TripViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrTrip.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath)
        let trip = arrTrip[indexPath.row]
        cell.textLabel?.text = trip.name
        if let count = trip.inventories?.allObjects.count{
            cell.detailTextLabel?.text = "Total Items \(count)"
        }else{
            cell.detailTextLabel?.text = "Total Items 0"
        }
        return cell
    }
    
}


extension TripViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromSelection{
            let trip = arrTrip[indexPath.row]
            DatabaseHelper.shareInstance.saveTripWithInventory(trip: trip, inventory: modelClothe!)
            self.navigationController?.popViewController(animated: true)
        }else{
            let clotheVC = InventoryViewController.shareInstance()
            clotheVC.modelTrip = arrTrip[indexPath.row]
            clotheVC.indexOfTrip = indexPath.row + 1
            self.navigationController?.pushViewController(clotheVC, animated: true)
        }
    }
}

extension TripViewController{
    static func shareInstance() -> TripViewController{
        return TripViewController.instantiateFromStoryboard()
    }
}
