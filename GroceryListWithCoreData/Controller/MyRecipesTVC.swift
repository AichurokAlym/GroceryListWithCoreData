//
//  MyRecipesTVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 30.10.22.
//

import UIKit
import CoreData

class MyRecipesTVC: UITableViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Recipe> = {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "recipeTitle", ascending: true)]

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

        self.title = "Meine Rezepte"

         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        fetchedResultsController.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
        
        // Cell einrichten
        let recipe = fetchedResultsController.object(at: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = recipe.recipeTitle
        cell.contentConfiguration = content
        
        return cell
    }
    

    
    //MARK: - prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailRecipeSegue" {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let dest = segue.destination as! DetailRecipeVC
            dest.recipe = fetchedResultsController.object(at: indexPath!)
        }
    }
    
    //MARK: - didSelectRowAt (TV Delegate)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "detailRecipeSegue", sender: cell)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = self.fetchedResultsController.object(at: indexPath)
            context.delete(recipe)
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

//MARK: Ext. FetchedResultsControllerDelegate
extension MyRecipesTVC: NSFetchedResultsControllerDelegate {
    
    // Wird aufgerufen, wenn Inhalt (Context) sich verändert:
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    
}



