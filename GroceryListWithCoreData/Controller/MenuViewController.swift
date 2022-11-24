//
//  MenuViewController.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.11.22.
//

import UIKit
import CoreData

class MenuViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var weekDaysCollectionView: UICollectionView!
    
    var dailyMenu = [WeeklyMenu]()
    var weekDays = [WeeklyPlanner]()
    var selectedDay: WeeklyPlanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.weekDaysCollectionView.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
        self.weekDaysCollectionView.dataSource = self
        self.weekDaysCollectionView.delegate = self
        
        fetchWeeklyMenu()
    
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func fetchWeeklyMenu() {

        let fetchRequest = WeeklyPlanner.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "indexOfDays", ascending: true)]
        
        do {
            weekDays = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            
            dailyMenu = try appDelegate.persistentContainer.viewContext.fetch(WeeklyMenu.fetchRequest())
            
        } catch {
            print(error)
        }
        collectionView.reloadData()
        weekDaysCollectionView.reloadData()
    }
}

extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == weekDaysCollectionView {
            return weekDays.count
        } else {
            return selectedDay?.weeklyMenu?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == weekDaysCollectionView {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
            
            let days = weekDays[indexPath.item]
            
            cell.weekDays.text = days.weekday
            
            if selectedDay == weekDays[indexPath.item] {
                cell.weekDays.backgroundColor = UIColor.orange
            } else {
                cell.weekDays.backgroundColor = UIColor.white
            }

           return cell
        } else {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
            
            let menu: WeeklyMenu = selectedDay?.weeklyMenu?.allObjects[indexPath.item] as! WeeklyMenu
        
            cell.productName.text = menu.mealTime
            cell.menu1TF.text = menu.menu1
            cell.menu2TF.text = menu.menu2
            cell.menu3TF.text = menu.menu3
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let days = weekDays[indexPath.item]
        selectedDay = days
        self.weekDaysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
       
        days.selectedDay = !days.selectedDay
        weekDaysCollectionView.deselectItem(at: indexPath, animated: true)
        fetchWeeklyMenu()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == weekDaysCollectionView{
            
            let weekDays = weekDays[indexPath.item].weekday
            let width = weekDays!.widthOfString(usingFont: UIFont.systemFont(ofSize: 20))
            return CGSize(width: width + 20, height: collectionView.frame.height)
            
        } else {
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
    
   
    
}
