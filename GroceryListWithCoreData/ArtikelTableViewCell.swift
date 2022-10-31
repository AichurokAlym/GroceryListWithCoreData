//
//  ArtikelTableViewCell.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.10.22.
//

import UIKit
import CoreData

class ArtikelTableViewCell: UITableViewCell {
    

    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var artikelImage: UIImageView!
    @IBOutlet weak var artikelName: UILabel!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    @IBAction func checkbox(_ sender: UIButton) {
        selectedItems()
        
    }
    
    func selectedItems() {
        
        checkbox.isSelected = !checkbox.isSelected
        if checkbox.isSelected == true {
            checkbox.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            
        } else {
            checkbox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
    }
}
