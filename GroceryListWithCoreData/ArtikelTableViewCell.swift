//
//  ArtikelTableViewCell.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.10.22.
//

import UIKit
import CoreData

class ArtikelTableViewCell: UITableViewCell {
    

    @IBOutlet weak var checkbox: UIImageView!
    @IBOutlet weak var artikelImage: UIImageView!
    @IBOutlet weak var artikelName: UILabel!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


  
}
