//
//  MyListTableViewCell.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 21.10.22.
//

import UIKit

class MyListTableViewCell: UITableViewCell {

    @IBOutlet weak var artikelImage: UIImageView!
    @IBOutlet weak var artikelName: UILabel!
    @IBOutlet weak var checkbox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
