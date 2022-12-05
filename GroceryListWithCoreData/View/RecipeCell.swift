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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
