//
//  MyRecipesTVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 30.10.22.
//

import UIKit
import CoreData

class MyRecipesTVC: UITableViewController {

//    var recipe = [Recipe]()
//    var selectedRecipe: Recipe!
    
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
        
        //fetchRecipes()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//        fetchRecipes()
//    }
    
//    func fetchRecipes() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        do {
//            recipe = try appDelegate.persistentContainer.viewContext.fetch(Recipe.fetchRequest())
//        } catch let error as NSError {
//          print(error.localizedDescription)
//        }
//        tableView.reloadData()
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return recipe.count
        return fetchedResultsController.sections![0].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
//        // Cell einrichten
//        var content = cell.defaultContentConfiguration()
//        content.text = recipe[indexPath.row].recipeTitle
//        cell.contentConfiguration = content
        
        // Cell einrichten
        let recipe = fetchedResultsController.object(at: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = recipe.recipeTitle
        cell.contentConfiguration = content
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//
//        selectedRecipe = recipe[indexPath.row]
//
//        return indexPath
//    }
    
    //MARK: - prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailRecipeSegue" {
//            let vc = segue.destination as! DetailRecipeVC
//            vc.recipe = selectedRecipe
            
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
//            let recipeToDelete = self.recipe[indexPath.row]
//            appDelegate.persistentContainer.viewContext.delete(recipeToDelete)
//            self.recipe.remove(at: indexPath.row)
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            appDelegate.saveContext()
            let recipe = self.fetchedResultsController.object(at: indexPath)
            context.delete(recipe)
            
            do {
                try context.save()
            } catch {
                print("Error")
            }
        }
    }
}

//MARK: Ext. FetchedResultsControllerDelegate
extension MyRecipesTVC: NSFetchedResultsControllerDelegate {
    
    // Wird ausgelöst, wenn Inhalt (Context) sich verändert:
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    
}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


