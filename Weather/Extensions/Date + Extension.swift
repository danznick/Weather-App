//
//  Date + Extension.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit

extension Date{
    
    var getTimeStamp: String{
        let nowDouble = self.timeIntervalSince1970
        let timeStamp = Int64(nowDouble*1000)
        return "\(timeStamp)"
    }
}
