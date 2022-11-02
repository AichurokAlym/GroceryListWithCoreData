//
//  MainScreenVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 19.10.22.
//

import UIKit
import CoreData

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var category = [Category]()
   
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //elaubnis das mehreren auswahl Möglichkeit
        tableView.allowsMultipleSelectionDuringEditing = true
        
        fetchCategory()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//        fetchCategory()
//    }
    
    func fetchCategory() {
        
        do {
            category = try appDelegate.persistentContainer.viewContext.fetch(Category.fetchRequest())
        } catch {
            print("Fehler")
        }
        print(category)
        tableView.reloadData()
    }
    

        @IBAction func toMyList(_ sender: UIButton) {
            
            //performSegue(withIdentifier: "toMyList", sender: self)
    }
    
}
    
extension HomeScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return category[section].categoryName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category[section].artikel?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ArtikelTableViewCell
        
        let artikel = category[indexPath.section].artikel?.allObjects[indexPath.row] as! Artikel
        
        if artikel.isChecked == false {
            cell.artikelName.text = artikel.artikelName
            cell.checkbox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            
            if let artikelImage = artikel.artikelImage {
                
                cell.artikelImage.image = UIImage(data: artikelImage)
                
            } else {
                cell.artikelImage.image = UIImage(systemName: "photo.artframe")
                
            }
        } else {
            cell.checkbox.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            
        }
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let artikelToDelete = self.category[indexPath.section].artikel?.allObjects[indexPath.row] as! Artikel
            appDelegate.persistentContainer.viewContext.delete(artikelToDelete)
            
            appDelegate.saveContext()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        } else if editingStyle == .insert {
            
        }
    }
    
    
    //
    //        func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
    //            true
    //        }
    //
    //        func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
    //            tableView.setEditing(true, animated: true)
    //        }
    //
    //        func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
    //            print("\(#function)")
    //        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ArtikelTableViewCell
        cell.selectedItems()
         
        let artikel = category[indexPath.section].artikel?.allObjects[indexPath.row] as! Artikel
        
//        if artikel.isChecked == true {
//            artikel.isChecked = false
//        } else {
//            artikel.isChecked = true
//        }
        
        artikel.isChecked = !artikel.isChecked
        
        

    }
   
    
    
}


