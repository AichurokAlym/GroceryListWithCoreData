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
    
    //var foddIcons = ["🍎", "🍇", "🥑", "🥝", "🫑", "🥨", "🧀", "🥖", "🍌", "🍓", "🍐"]
    
    //gecheckte Artikeln in einem Array speichern
    var isSelectedItems = [Artikel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // mehrere auswahl Möglichkeiten werden erlaubt
        tableView.allowsMultipleSelectionDuringEditing = true
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        for categorien in category {
            for artikeln in (categorien.artikel?.allObjects as! [Artikel]) {
                artikeln.isChecked = false
            }
        }
        tableView.reloadData()
    }
    
    func selectedItems () {
        
        for items in category {
            for artikeln in (items.artikel?.allObjects as! [Artikel]) {
                if artikeln.isChecked {
                    self.isSelectedItems.append(artikeln)
                }
            }
        }
    }

    @IBAction func toMyList(_ sender: UIButton) {
        
        let myListVC = storyboard?.instantiateViewController(withIdentifier: "toMyList") as! MyListTVC

        for items in category {
            for artikeln in (items.artikel?.allObjects as! [Artikel]) {
                if artikeln.isChecked {
                    self.isSelectedItems.append(artikeln)
                }
            }
        }
        
        let myList = isSelectedItems
        myListVC.myList = myList
        navigationController?.pushViewController(myListVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMyList" {
            let vc = 
        }
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
            cell.checkbox.image = UIImage(systemName: "checkmark.seal")
            
            if let artikelImage = artikel.artikelImage {
                
                cell.artikelImage.image = UIImage(data: artikelImage)
                
            } else {
                cell.artikelImage.image = UIImage(systemName: "photo.artframe")
                
            }
        } else {
            cell.checkbox.image = UIImage(systemName: "checkmark.seal.fill")
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ArtikelTableViewCell
        
        let artikel = category[indexPath.section].artikel?.allObjects[indexPath.row] as! Artikel
        
        artikel.isChecked = !artikel.isChecked
        
        if artikel.isChecked {
            cell.checkbox.image = UIImage(systemName: "checkmark.seal.fill")
        } else {
            cell.checkbox.image = UIImage(systemName: "checkmark.seal")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
}


