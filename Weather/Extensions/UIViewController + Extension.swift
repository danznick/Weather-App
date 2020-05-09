//
//  UIViewController + Extension.swift
//  Weather
//
//  Created by Daniel Gomes on 26/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self
    {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T // Generic Type
    {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "\(Self.self)") as! T
        return controller
    }
    
    func popupAlert(title: String, message: String, alertControllerStyle: UIAlertController.Style, actionTitles: [String], actionStyles: [UIAlertAction.Style], alertActions: [((UIAlertAction) -> Void)]){
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
        for (index, title) in actionTitles.enumerated(){
            let action = UIAlertAction(title: title, style: actionStyles[index], handler: alertActions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
