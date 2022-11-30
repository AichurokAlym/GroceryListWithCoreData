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
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    var dailyMenu = [WeeklyMenu]()
    var weekDays = [WeeklyPlanner]()
    var selectedDay: WeeklyPlanner?
    
    var menuToDelete: [IndexPath] = []
    
    let arrColors = ["d9d2e9", "dfe3f0", "d2d4dc", "fff0db", "eafff2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.weekDaysCollectionView.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
        self.weekDaysCollectionView.dataSource = self
        self.weekDaysCollectionView.delegate = self
        
        // erlaubt mehrfache Auswahl von Items
        collectionView.allowsMultipleSelection = true
        
        collectionView.backgroundColor = UIColor.clear
        weekDaysCollectionView.backgroundColor = UIColor.clear
        
        fetchWeeklyMenu()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        let randomIndex = Int(arc4random_uniform(UInt32(arrColors.count)))
//        view.backgroundColor = hexStringToUIColor(hex: arrColors[randomIndex])
        
        fetchWeeklyMenu()
        collectionView.reloadData()
    }
    
    func fetchWeeklyMenu() {

        let fetchRequest = WeeklyPlanner.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "indexOfDays", ascending: true)]
        
        do {
            weekDays = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            var tag = "Montag"
            if selectedDay != nil {
                tag = selectedDay!.weekday!
            }
            let fetchRequestMenu = WeeklyMenu.fetchRequest()
            fetchRequestMenu.predicate = NSPredicate(format: "weeklyPlanner.weekday == %@", tag)
            dailyMenu = try appDelegate.persistentContainer.viewContext.fetch(fetchRequestMenu)
            
        } catch {
            print(error)
        }
        collectionView.reloadData()
        weekDaysCollectionView.reloadData()
    }
    
    @IBAction func trashBtnTapped(_ sender: UIBarButtonItem) {
        for i in menuToDelete.sorted(by: {$0.item > $1.item}) {
            context.delete(dailyMenu[i.item])
            dailyMenu.remove(at: i.item)
        }
        collectionView.deleteItems(at: menuToDelete)
        menuToDelete.removeAll()
        appDelegate.saveContext()
        trashButton.isEnabled = false
    }
    
}

extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == weekDaysCollectionView {
            return weekDays.count
        } else {
            return dailyMenu.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == weekDaysCollectionView {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
            
            let days = weekDays[indexPath.item]
            
            cell.weekDays.text = days.weekday
            
            if selectedDay == weekDays[indexPath.item] {
                cell.backgroundColor = UIColor.white
                // Zugriff auf Design via Layer:
                cell.layer.cornerRadius = 10
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowRadius = 3.0
                cell.layer.shadowOpacity = 1.0
                cell.layer.shadowOffset = CGSize(width: 4, height: 4)
                cell.layer.masksToBounds = false
            } else {
                cell.weekDays.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                cell.layer.shadowColor = UIColor.clear.cgColor
            }

           return cell
        } else {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
            //cell.backgroundColor = UIColor.clear
            let menu: WeeklyMenu = dailyMenu[indexPath.item]
        
            cell.productName.text = menu.mealTime
            cell.menu1TF.text = menu.menu1
            cell.menu2TF.text = menu.menu2
            cell.menu3TF.text = menu.menu3
            
            // Zugriff auf Design via Layer:
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.layer.borderColor = UIColor.systemMint.cgColor
            cell.layer.borderWidth = 6
            
            let randomIndex = Int(arc4random_uniform(UInt32(arrColors.count)))
            cell.backgroundColor = hexStringToUIColor(hex: arrColors[randomIndex])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let days = weekDays[indexPath.item]
        selectedDay = days
        if collectionView == self.weekDaysCollectionView {
            self.weekDaysCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
       
        days.selectedDay = !days.selectedDay
        weekDaysCollectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == self.collectionView {
            self.menuToDelete.append(indexPath)
        }
        
        trashButton.isEnabled = true
        
        if collectionView == weekDaysCollectionView {
            fetchWeeklyMenu()
            collectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        self.menuToDelete.remove(at: menuToDelete.firstIndex(of: indexPath)!)
        if menuToDelete.isEmpty {
            trashButton.isEnabled = false
        }
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

