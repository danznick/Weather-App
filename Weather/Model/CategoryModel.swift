//
//  CategoryModel.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//
/// Datamodel for storing category in cellView

import UIKit

struct CategoryModel{
    var name = ""
    var layer = ""
    var cloValue = ""
      
    static let arrCategory: [CategoryModel] = [
        CategoryModel(name: "GEAR", layer: "N/A", cloValue: "0.00"),
        CategoryModel(name: "Custom Jacket", layer: "outer", cloValue: "0.00"),
        
        CategoryModel(name: "Generic Shirt, short-sleeved", layer: "Inner layer", cloValue: "0.12"),
        CategoryModel(name: "Generic Shirt, long-sleeved", layer: "Inner layer", cloValue: "0.10"),
        CategoryModel(name: "Generic Bottom, short-sleeved", layer: "Inner layer", cloValue: "0.08"),
        CategoryModel(name: "Generic Bottom, long-sleeved", layer: "Inner layer", cloValue: "0.10"),
        CategoryModel(name: "Generic Shirt, thin", layer: "Middle layer", cloValue: "0.20"),
        CategoryModel(name: "Generic Shirt, thick (woollen, fleece, comparable)", layer: "Middle layer", cloValue: "0.35"),
        CategoryModel(name: "Generic Jacket, thick", layer: "Outermost layer ", cloValue: "0.40"),
        CategoryModel(name: "Generic Trousers, thick", layer: "Outermost layer ", cloValue: "0.35"),
        CategoryModel(name: "Generic Cap, hat, balaclava or comparable", layer: "Headgear", cloValue: "0.01"),
        CategoryModel(name: "Generic Warm winter cap (woollen, fleece, comparable)", layer: "Headgear", cloValue: "0.03"),
        CategoryModel(name: "Generic Socks, wool thick", layer: "Other gear", cloValue: "0.15"),
        CategoryModel(name: "Generic Boots, winter, rubber", layer: "Other gear", cloValue: "0.11")
  
    ]
}

 
