//
//  MenuViewController.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.11.22.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var weekDaysCollectionView: UICollectionView!
    
    var menu: Menu = Menu()
    var selectedDayIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.weekDaysCollectionView.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
        self.weekDaysCollectionView.dataSource = self
        self.weekDaysCollectionView.delegate = self
    }
}

extension MenuViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == weekDaysCollectionView{
            return menu.weekDays.count
        }else{
            let meal = menu.weekDays[selectedDayIndex]
            return meal.food.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == weekDaysCollectionView{
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
            let days = menu.weekDays[indexPath.item]
           cell.setupCell(days: days)
           return cell
        }else{
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
            let days = menu.weekDays[selectedDayIndex]
            let meal = days.food[indexPath.item]
              cell.setupCell(meal: meal)
              return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == weekDaysCollectionView{
            
            let weekDays = menu.weekDays[indexPath.item].days
            let width = weekDays.widthOfString(usingFont: UIFont.systemFont(ofSize: 17))
            return CGSize(width: width + 20, height: collectionView.frame.height)
            
        }else{
             return CGSize(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == weekDaysCollectionView {
            
            self.selectedDayIndex = indexPath.item
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            self.collectionView.reloadData()
        }
    }
    
}
