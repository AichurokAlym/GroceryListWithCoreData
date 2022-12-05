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
    
    var selectedDay: WeeklyPlanner?
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
        
        self.descriptionTextView.inputAccessoryView = createToolbar()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchWeeklyPlanner()
        if selectedDay != nil {
            weekDayPickerView.selectRow(Int(selectedDay!.indexOfDays), inComponent: 0, animated: true)
        }
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
    
    //MARK: TextFields keyboards schließen
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Text View Keyboard schließen
    @objc func doneBtnTapped() {
        descriptionTextView.resignFirstResponder()
    }
    
    func createToolbar() -> UIToolbar {
        
        // Toolbar Instanz erstellen
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Done-Button einfügen
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnTapped))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    //MARK: - Keyboard-Überlappung regeln
//    @objc func keyboardWillShow(notification: NSNotification){
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 && descriptionTextView.isFirstResponder {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
