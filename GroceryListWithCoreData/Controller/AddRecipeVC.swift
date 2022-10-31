//
//  AddResipeVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 30.10.22.
//

import UIKit

class AddRecipeVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate {
    
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
            recipe.cookingTime = Int64(cookingTimeTF.text!) ?? 0
            
            for ingredient in ingredientTableViewData {
                //recipe.addToIngredients(ingredient)
            }
            
            do {
                try context.save()
            } catch {
                print("Error while saving AddRecipeVC")
            }
            
            //NotificationCenter.default.post(name: NSNotification.Name.init("de.RezepteOrganizer.saveRecipe"), object: recipe)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // Image hinzufügen
    
    @IBAction func addImageBtnTapped(_ sender: UIButton) {
        recipeImageView.image = UIImage(named: "spaghetti-napoli")
    }
    
    
    // Ingredients hinzufügen
    @IBAction func addIngredientBtnTapped(_ sender: UIButton) {
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
