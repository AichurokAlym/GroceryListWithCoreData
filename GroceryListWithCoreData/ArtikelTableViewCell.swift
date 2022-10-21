//
//  ArtikelTableViewCell.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.10.22.
//

import UIKit

class ArtikelTableViewCell: UITableViewCell {
    

    @IBOutlet weak var checkbox: CheckboxButton!
    @IBOutlet weak var artikelImage: UIImageView!
    @IBOutlet weak var artikelName: UILabel!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    @IBAction func checkbox(_ sender: UIButton) {
        print("AAA")
        checkbox.isSelected = !checkbox.isSelected
        if checkbox.isSelected == true {
            checkbox.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            checkbox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
    }
}
