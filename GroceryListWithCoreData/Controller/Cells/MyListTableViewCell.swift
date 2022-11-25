//
//  MyListTableViewCell.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 21.10.22.
//

import UIKit

class MyListTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var artikelImage: UIImageView!
    @IBOutlet weak var artikelName: UILabel!
    @IBOutlet weak var artikelQuantityTF: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    var artikel: Artikel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.artikelQuantityTF.delegate = self
        
        self.artikelImage.layer.cornerRadius = 15
        self.artikelImage.clipsToBounds = true
        self.artikelImage.layer.borderColor = UIColor.black.cgColor
        self.artikelImage.layer.borderWidth = 4
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        artikel?.quantity = self.artikelQuantityTF.text
        
        if let text = artikelQuantityTF.text, !text.isEmpty {
            quantityLabel.isHidden = false
            quantityLabel.text = artikelQuantityTF.text
            artikelQuantityTF.isHidden = true
            appDelegate.saveContext()
        }
        return false
    }

}
