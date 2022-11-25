//
//  AddMenuViewController.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 22.11.22.
//

import UIKit

class AddMenuViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
  
    @IBOutlet weak var mealTimeTF: UITextField!
    @IBOutlet weak var menu1TF: UITextField!
    @IBOutlet weak var menu2TF: UITextField!
    @IBOutlet weak var menu3TF: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var weekDayPickerView: UIPickerView!
    
    var selectedDay: WeeklyPlanner!
    var weekDays = [WeeklyPlanner]()
    var dailyMenu = [WeeklyMenu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mealTimeTF.delegate = self
        menu1TF.delegate = self
        menu2TF.delegate = self
        menu3TF.delegate = self
        descriptionTextView.delegate = self
        weekDayPickerView.delegate = self
        weekDayPickerView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchWeeklyPlanner()
    }
    
    func fetchWeeklyPlanner() {
        
        let fetchRequest = WeeklyPlanner.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "indexOfDays", ascending: true)]
        
        do {
            weekDays = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        weekDayPickerView.reloadAllComponents()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
        let menu = WeeklyMenu(context: context)
        menu.weeklyPlanner = selectedDay
        if let mealTime = mealTimeTF.text, mealTimeTF.text != "" {
           
            menu.mealTime = mealTime
        }
        if let menu1 = menu1TF.text, menu1TF.text != "" {
            menu.menu1 = menu1
        }
        if let menu2 = menu2TF.text, menu2TF.text != "" {
            menu.menu2 = menu2
        }
        if let menu3 = menu3TF.text, menu3TF.text != "" {
            menu.menu3 = menu3
        }
        
        self.navigationController?.popViewController(animated: true)
        appDelegate.saveContext()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weekDays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weekDays[row].weekday
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDay = weekDays[row]
     
    }
    
}
