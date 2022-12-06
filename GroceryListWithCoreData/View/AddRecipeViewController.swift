//
//  AddRecipeViewController.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 02.12.22.
//

import UIKit
import CoreData
import PhotosUI

class AddRecipeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UITableViewDelegate {

    @IBOutlet weak var recipeTitleTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var cookingTimeTF: UITextField!
    @IBOutlet weak var instructionsTV: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientNameTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var unitTF: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    

    
    // Datengrundlage zur TableView
    var ingredientTableViewData = [Ingredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ingredientTableView.dataSource = self
        
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: TextFields keyboards schließen
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Text View Keyboard schließen
    @objc func doneBtnTapped() {
        instructionsTV.resignFirstResponder()
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
    
//    MARK: - Keyboard-Überlappung regeln
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && ingredientNameTF.isFirstResponder  {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
        
        if let recipeTitle = recipeTitleTF.text, recipeTitleTF.text != "" {
            
            // Hier wird ein Rezept erstellt
            let recipe = Recipe(context: context)
            recipe.recipeTitle = recipeTitle
            
            // UIImage wird in Data? umgewandelt und dann in die image-Property der Recipe-Instanz geladen
            let imageData = recipeImageView.image!.jpegData(compressionQuality: 1.0)
            recipe.image = imageData
            
            recipe.category = categoryTF.text
            recipe.instructions = instructionsTV.text
            recipe.cookingTime = cookingTimeTF.text
            
            for ingredient in ingredientTableViewData {
                recipe.addToIngredients(ingredient)
            }
            
            do {
                try context.save()
            } catch {
                print("Error while saving AddRecipeVC")
            }
        }
        appDelegate.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    
    // Image hinzufügen
    @IBAction func addImageBtnTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = PHPickerFilter.any(of: [.images, .panoramas])
         let photoPicker = PHPickerViewController(configuration: config)
        photoPicker.delegate = self
        self.present(photoPicker, animated: true)
    }
    
    // Ingredients hinzufügen
    @IBAction func addIngredientBtnTapped(_ sender: UIButton) {

        ingredientTableView.isHidden = false
        
        if let ingredientName = ingredientNameTF.text, let quantity = quantityTF.text, let unit = unitTF.text, ingredientNameTF.text != "" {
            
            let ingredient = Ingredient(context: context)
            ingredient.name = ingredientName
            ingredient.quantity = Float(quantity) ?? 0
            ingredient.unit = unit
            
            ingredientTableViewData.append(ingredient)
            ingredientTableView.reloadData()
            
            ingredientNameTF.text = ""
            quantityTF.text = ""
            unitTF.text = ""
        }
    }
    
}

//MARK: - Ext. TableView Data Source
extension AddRecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell registrieren
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddIngredientCell", for: indexPath)
        
        // Inhalte der Cells einrichten
        var content = cell.defaultContentConfiguration()
        content.text = ingredientTableViewData[indexPath.row].name
        content.secondaryText = "\(ingredientTableViewData[indexPath.row].quantity) \(ingredientTableViewData[indexPath.row].unit!)"
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.ingredientTableViewData.remove(at: indexPath.row)
            self.ingredientTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension AddRecipeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { proveiderReading, error in
                if let error = error {
                    print(error)
                    return
                }
                if let proveiderReading = proveiderReading {
                    let image = proveiderReading as! UIImage
                    DispatchQueue.main.async {
                        self.recipeImageView.image = image
                    }
                }
            }
        }
    }
}
