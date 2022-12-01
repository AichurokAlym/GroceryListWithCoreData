//
//  AddResipeVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 30.10.22.
//

import UIKit
import CoreData
import PhotosUI

class AddRecipeVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UITableViewDelegate {
    
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

    }
    
    //MARK: - IBActions
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
            recipe.cookingTime = Int16(cookingTimeTF.text!) ?? 0
            recipe.image = recipeImageView.image?.pngData()
            
            for ingredient in ingredientTableViewData {
                recipe.addToIngredients(ingredient)
            }
            
            do {
                try context.save()
            } catch {
                print("Error while saving AddRecipeVC")
            }
        }
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
extension AddRecipeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Cell registrieren
        let cell = tableView.dequeueReusableCell(withIdentifier: "addIngredientCell", for: indexPath)
        
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

extension AddRecipeVC: PHPickerViewControllerDelegate {
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
