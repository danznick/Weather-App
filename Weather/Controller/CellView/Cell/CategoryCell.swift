//
//  CategoryCell.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLayer: UILabel!
    @IBOutlet weak var lblCloValue: UILabel!
    
    var modelCategory: CategoryModel?{
        didSet{
            lblName.text = modelCategory?.name
            lblLayer.text = modelCategory?.layer
            lblCloValue.text = modelCategory?.cloValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
