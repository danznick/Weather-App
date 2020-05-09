//
//  ClotheCell.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit

class InventoryCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel! //Change for features
    var modelClother: Inventory?{
        didSet{
            updateData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData(){
        img.image = modelClother?.imgPath?.getImage()
        lblName.text = "\(modelClother?.name ?? "")"
        lblPrice.text = "KG:\(modelClother?.weight ?? "")" // Change to HSA
    }
    
}
