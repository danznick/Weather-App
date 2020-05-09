//
//  String + Extension.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit

extension String{ //(converts String in to
    func saveImageDocumentDirectory(img: UIImage){
        let paths = (getDirectoryPath() as NSString).appendingPathComponent(self)
        let imgData = img.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String, contents: imgData, attributes: nil)
    }
    
    func getDirectoryPath() -> Self{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func getImage() -> UIImage?{
        let imgPath = (getDirectoryPath() as NSString).appendingPathComponent(self) // file path 
        if fileManager.fileExists(atPath: imgPath){
            return UIImage(contentsOfFile: imgPath)
        }else{
            return nil
        }
    }
    
}
