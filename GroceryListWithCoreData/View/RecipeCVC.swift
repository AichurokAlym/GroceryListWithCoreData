//
//  RecipeCVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 06.12.22.
//

import UIKit

private let reuseIdentifier = "RecipeCell"

class RecipeCVC: UICollectionViewController {

    @IBOutlet var recipeCollectionView: UICollectionView!
    
    var recipies = [Recipe]()
    var recipiesToDelete: [IndexPath] = []
    
    let sectionInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 10.0)
    let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Rezepte"
        
        // Register cell classes
        self.recipeCollectionView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCell")
        self.recipeCollectionView.dataSource = self
        self.recipeCollectionView.delegate = self
        
        fetchRecipe()
        addLongPressFunctionality()
        configureItems()
        recipeCollectionView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appDelegate.saveContext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(isEditing)
        fetchRecipe()
        recipeCollectionView.reloadData()
    }
    
    func fetchRecipe() {
        do {
            recipies = try appDelegate.persistentContainer.viewContext.fetch(Recipe.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    private func configureItems() {
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipeBtn))
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
       super.setEditing(editing, animated: animated)
       print(editing)
        recipeCollectionView.allowsMultipleSelection = editing
        recipeCollectionView.indexPathsForVisibleItems.forEach { (indexPath) in
            let cell = recipeCollectionView.cellForItem(at: indexPath) as!
                RecipeCell
            cell.isEditing = editing
            
            if editing {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deletingBtn))
            } else {
                navigationItem.rightBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipeBtn))
            }
        }
    }
    
    @objc func addRecipeBtn() {
        performSegue(withIdentifier: "toAddRecipe", sender: self)
    }
    
    @objc func deletingBtn() {
        
        for i in recipiesToDelete.sorted(by: {$0.item > $1.item}) {
            context.delete(recipies[i.item])
            recipies.remove(at: i.item)
        }
        recipeCollectionView.deleteItems(at: recipiesToDelete)
        recipiesToDelete.removeAll()
        appDelegate.saveContext()
        if recipies.count < 1 {
            configureItems()
            isEditing = false
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
        return recipies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCell
    
        // Configure the cell
        let recipe: Recipe = recipies[indexPath.item]
        cell.recipeTitle.text = recipe.recipeTitle
        cell.cookingTime.text = recipe.cookingTime
        cell.category.text = recipe.category
        cell.recipeImage.image = UIImage(data: recipe.image!)
        
        // Zugriff auf Design via Layer:
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.systemMint.cgColor
        cell.layer.borderWidth = 6
        
        cell.isEditing = isEditing
    
        return cell
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: recipeCollectionView.frame.width / 2, height: 120)
    }
    
    //MARK: - prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedItem = sender as? Recipe else {
            return
        }
        if segue.identifier == "toDetailRecipeViewController" {
            guard let destinationVC = segue.destination as? DetailRecipeViewController else {
                return
            }
            destinationVC.recipe = selectedItem
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            let selectedRecipe = recipies[indexPath.item]
            self.performSegue(withIdentifier: "toDetailRecipeViewController", sender: selectedRecipe)
        } else {
            self.recipiesToDelete.append(indexPath)
        }
    }
    

    // moving cell
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let recipe = recipies.remove(at: sourceIndexPath.item)
        recipies.insert(recipe, at: destinationIndexPath.item)
    }
    
    func addLongPressFunctionality() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressgesture(gesture:)))
        self.recipeCollectionView.addGestureRecognizer(longPress)
    }

    @objc func longPressgesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath =
                    recipeCollectionView.indexPathForItem(at: gesture.location(in: recipeCollectionView)) else { return }
            recipeCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            recipeCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            recipeCollectionView.endInteractiveMovement()
        default:
            recipeCollectionView.cancelInteractiveMovement()
        }
    }
}

// MARK: - Collection view delegate flow layout
extension RecipeCVC: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow

    return CGSize(width: widthPerItem, height: widthPerItem)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return sectionInsets
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return sectionInsets.left
  }
    
}

////MARK: Ext. FetchedResultsControllerDelegate
//extension RecipeCVC: NSFetchedResultsControllerDelegate {
//    // Wird aufgerufen, wenn Inhalt (Context) sich verändert:
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        recipeCollectionView.reloadData()
//    }
//}



