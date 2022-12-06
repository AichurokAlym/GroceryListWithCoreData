//
//  DetailRecipeViewController.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 02.12.22.
//

import UIKit
import CoreData

class DetailRecipeViewController: UIViewController {
   
    //MARK: Outlets und Variablen und Context
    var recipe: Recipe!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitleTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var cookingTimeTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructionsTV: UITextView!
    
    //MARK: - fetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<Ingredient> = {
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = NSPredicate(format: "recipes CONTAINS[cd] %@", recipe)

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
        recipeTitleTF.text = recipe.recipeTitle
        
        if let image = recipe.image {
            recipeImage.image = UIImage(data: image)
        } else {
            recipeImage.image = UIImage(systemName: "photo.artframe")
        }
        
        categoryTF.text = recipe.category
        cookingTimeTF.text = recipe.cookingTime
        instructionsTV.text = recipe.instructions
        
        fetchedResultsController.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - Ext. controllerDelegate
extension DetailRecipeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

//MARK: - Ext. TV Data Source
extension DetailRecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailIngredientCell", for: indexPath)
        let ingredient = self.fetchedResultsController.object(at: indexPath)
        // Content erstellen
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
                print(error)
            }
        }
    }
}
