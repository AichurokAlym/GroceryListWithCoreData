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
    var artikeln = [Artikel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        fetchCategory()
        
    }
    
    func fetchCategory() {
        
        do {
            category = try appDelegate.persistentContainer.viewContext.fetch(Category.fetchRequest())
        } catch {
            print("Fehler")
        }
        print(category)
        tableView.reloadData()
    }
    
    func selectedArtikel(sender: CheckboxButton) {
        
//        print(sender.artikel)
//        print(sender.category)
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
        
        cell.checkbox.imageView?.image = UIImage(systemName: "checkmark.circle")
        
        let artikel = category[indexPath.section].artikel?.allObjects[indexPath.row] as! Artikel
        
        print("#" + artikel.artikelName!)
        
        cell.artikelName.text = artikel.artikelName
        if let artikelImage = artikel.artikelImage {
            print("##" )
            cell.artikelImage.image = UIImage(data: artikelImage)

        } else {
            
            cell.artikelImage.image = UIImage(systemName: "photo.artframe")
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
    
    
  
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        tableView.setEditing(true, animated: true)
    }
    
    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        print("\(#function)")
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
}




