//
//  RecipeCell.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 02.12.22.
//

import UIKit

class RecipeCell: UICollectionViewCell {

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var cookingTime: UILabel! 
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var checkmark: UIImageView!
    
    
    var isEditing: Bool = false {
        didSet {
            checkmark.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                checkmark.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                checkmark.image = UIImage(systemName: "checkmark.circle")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
