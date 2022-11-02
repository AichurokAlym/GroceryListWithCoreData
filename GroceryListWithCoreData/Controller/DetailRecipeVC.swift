//
//  DetailRecipeVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 30.10.22.
//

import UIKit
import CoreData

class DetailRecipeVC: UIViewController {
    
    //MARK: Outlets und Variablen und Context
    var recipe: Recipe!
    
    
    @IBOutlet weak var recipeTitleTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var cookingTimeTF: UITextField!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientNameTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var unitTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var instructionsTV: UITextView!
    @IBOutlet weak var ingredientView: UIView!
    
    
    //MARK: - fetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<Ingredient> = {
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = NSPredicate(format: "recipes = %@", recipe)

        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        do {
            try controller.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return controller
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = recipe.recipeTitle
        recipeTitleTF.text = recipe.recipeTitle
        categoryTF.text = recipe.category
        cookingTimeTF.text = recipe.cookingTime.description
        instructionsTV.text = recipe.instructions
        //recipeImage.image = UIImage(data: recipe.image!)
        
        fetchedResultsController.delegate = self
        tableView.dataSource = self
        
    
    }
    
    //MARK: - IBActions
    // Editieren: Eingabe ermöglichen
    @IBAction func editBtnTapped(_ sender: UIBarButtonItem) {
        
        if ingredientView.isHidden {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(editBtnTapped(_:)))
            
            imageBtn.isHidden = false
            ingredientView.isHidden = false
            
            saveBtn.isEnabled = true
            recipeTitleTF.isEnabled = true
            cookingTimeTF.isEnabled = true
            categoryTF.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnTapped(_:)))
            
            imageBtn.isHidden = true
            ingredientView.isHidden = true
            
            saveBtn.isEnabled = false
            recipeTitleTF.isEnabled = false
            cookingTimeTF.isEnabled = false
            categoryTF.isEnabled = false
            
            recipeTitleTF.text = recipe.recipeTitle
            categoryTF.text = recipe.category
            cookingTimeTF.text = recipe.cookingTime.description
        }
        
    }
    
    // Ingredients hinzufügen
    @IBAction func addIngredientBtnTapped(_ sender: UIButton) {
        
        if let ingredientName = ingredientNameTF.text, let quantity = quantityTF.text, let unit = unitTF.text, ingredientNameTF.text != "" {
            
            let ingredient = Ingredient(context: context)
            ingredient.name = ingredientName
            ingredient.quantity = Float(quantity) ?? 0
            ingredient.unit = unit
            
            //recipe.addToIngredients(ingredient)
            
            ingredientNameTF.text = ""
            quantityTF.text = ""
            unitTF.text = ""
        }
    }
    
    // Recipe speichern
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
 
        if let recipeTitle = recipeTitleTF.text, recipeTitleTF.text != "" {
            recipe.recipeTitle = recipeTitle
            recipe.category = categoryTF.text
            recipe.instructions = instructionsTV.text
            //recipe.cookingTime = Int64(cookingTimeTF.text!) ?? 0
            
            sender.isEnabled = false
            recipeTitleTF.isEnabled = false
            imageBtn.isHidden = true
            ingredientView.isHidden = true
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnTapped(_:)))
            
            do {
                try context.save()
            } catch {
                print("Error while saving")
            }
        }
        
    }
    
}

//MARK: - Ext. controllerDelegate
extension DetailRecipeVC: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

//MARK: - Ext. TV Data Source
extension DetailRecipeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        // Content erstellen
        let ingredient = self.fetchedResultsController.object(at: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = ingredient.name
        content.secondaryText = "\(ingredient.quantity) \(ingredient.unit!)"
        cell.contentConfiguration = content
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ingredient = self.fetchedResultsController.object(at: indexPath)
            context.delete(ingredient)
            
            do {
                try context.save()
            } catch {
                print("Error")
            }
        }
    }
}
