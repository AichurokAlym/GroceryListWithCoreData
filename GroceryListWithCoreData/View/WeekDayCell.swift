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

    func setupCell(days: MealPlan, isSelected: Bool){
        self.weekDays.text = days.days
        
        if isSelected {
            self.contentView.backgroundColor = .orange
        } else {
            self.contentView.backgroundColor = .white
        }
    }
}
