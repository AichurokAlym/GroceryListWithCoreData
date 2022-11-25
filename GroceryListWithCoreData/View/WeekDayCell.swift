//
//  WeekDayCell.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.11.22.
//

import UIKit

class WeekDayCell: UICollectionViewCell {

    @IBOutlet weak var weekDays: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
             let fontAttributes = [NSAttributedString.Key.font: font]
             let size = (self as NSString).size(withAttributes: fontAttributes)
             return ceil(size.width)
    }
}
