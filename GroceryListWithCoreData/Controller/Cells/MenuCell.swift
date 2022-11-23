//
//  MenuCell.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.11.22.
//

import UIKit

class MenuCell: UICollectionViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var menu1TF: UITextField!
    @IBOutlet weak var menu2TF: UITextField!
    @IBOutlet weak var menu3TF: UITextField!
    @IBOutlet weak var menu4TF: UITextField!
    @IBOutlet weak var commentaryTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
