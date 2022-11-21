//
//  Menu.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.11.22.
//

import Foundation
import UIKit

struct MealPlan {
    var days: String
    var food: [Meal]
}

struct Meal {
    var name: String
}

class Menu {
    var weekDays = [MealPlan]()
    
    init() {
        setup()
    }
    
    func setup() {
        let p1 = Meal(name: "Frühstück")
        let p2 = Meal(name: "Mittagessen")
        let p3 = Meal(name: "Abendessen")
        let p4 = Meal(name: "Menu4")
        let p5 = Meal(name: "Menu5")
        let p6 = Meal(name: "Menu6")
       
        let menu1 = [p1, p2, p3]
        let menu2 = [p4, p5, p6]
        
        
        
        let monday = MealPlan(days: "Montag", food: menu1)
        let tuesday = MealPlan(days: "Dienstag", food: menu2)
        let wednesday = MealPlan(days: "Mittwoch", food: menu1)
        let thursday = MealPlan(days: "Donnerstag", food: menu2)
        let friday = MealPlan(days: "Freitag", food: menu1)
        let saturday = MealPlan(days: "Samstag", food: menu2)
        let sunday = MealPlan(days: "Sonntag", food: menu1)
        
        self.weekDays = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
             let fontAttributes = [NSAttributedString.Key.font: font]
             let size = (self as NSString).size(withAttributes: fontAttributes)
             return ceil(size.width)
    }
}
