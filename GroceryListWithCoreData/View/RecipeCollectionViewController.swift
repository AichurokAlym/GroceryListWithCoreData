//
//  RecipeCollectionViewController.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 02.12.22.
//

import UIKit
import CoreData

private let reuseIdentifier = "RecipeCell"

class RecipeCollectionViewController: UICollectionViewController {

    @IBOutlet var recipeCollectionView: UICollectionView!
    
    var recipies = [Recipe]()
    var recipiesToDelete: [IndexPath] = []
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.title = "Rezepte"
        
        // Register cell classes
        self.recipeCollectionView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCell")
        self.recipeCollectionView.dataSource = self
        self.recipeCollectionView.delegate = self
        fetchedResultsController.delegate = self
        
        // erlaubt mehrfache Auswahl von Items
        recipeCollectionView.allowsMultipleSelection = true
        recipeCollectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appDelegate.saveContext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        recipeCollectionView.reloadData()
    }

   

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchedResultsController.sections![0].numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCell
    
        // Configure the cell
        let recipe = fetchedResultsController.object(at: indexPath)
        cell.recipeTitle.text = recipe.recipeTitle
        cell.cookingTime.text = recipe.cookingTime
        print(recipe.cookingTime)
        cell.category.text = recipe.category
        cell.recipeImage.image = UIImage(data: recipe.image!)
        
        // Zugriff auf Design via Layer:
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.systemMint.cgColor
        cell.layer.borderWidth = 6
        
    
        return cell
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: recipeCollectionView.frame.width / 2, height: 120)
    }
    
    //MARK: - prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailRecipeViewController" {
            let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)
            let dest = segue.destination as! DetailRecipeViewController
            dest.recipe = fetchedResultsController.object(at: indexPath!)
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.performSegue(withIdentifier: "toDetailRecipeViewController", sender: cell)

    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

//MARK: Ext. FetchedResultsControllerDelegate
extension RecipeCollectionViewController: NSFetchedResultsControllerDelegate {
    // Wird aufgerufen, wenn Inhalt (Context) sich verändert:
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
    
}
