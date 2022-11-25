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
    @IBOutlet weak var commentaryTextView: UITextView!
    @IBOutlet weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commentaryTextView.layer.cornerRadius = 15
        self.commentaryTextView.clipsToBounds = true
        self.commentaryTextView.layer.borderColor = UIColor.purple.cgColor
        self.commentaryTextView.layer.borderWidth = 2
    }
    
    // kümmert sich um die Anzeige einer Auswahl
    override var isSelected: Bool{
        didSet {
            if(isSelected) {
                
                checkMark.isHidden = false
                print("AAAA")
            } else {
                checkMark.isHidden = true
            }
        }
    }

}
