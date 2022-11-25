//
//  MyListTVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 21.10.22.
//

import UIKit
import CoreData

class MyListTVC: UITableViewController {
    
    var myList = [Artikel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCategory()
        tableView.reloadData()
    }

    func fetchCategory() {
        do {
           let alleArtikel = try appDelegate.persistentContainer.viewContext.fetch(Artikel.fetchRequest())
            for artikel in alleArtikel {
                if artikel.isChecked {
                    if !myList.contains(artikel) {
                        myList.append(artikel)
                    }
                } else {
                    if myList.contains(artikel) {
                        myList.remove(at: myList.firstIndex(of: artikel)!)
                    }
                }
            }
        } catch {
            print("Fehler")
        }
        tableView.reloadData()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Einkaufsliste"
        } else {
            return "Gefundene - Gekaufte Liste"
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myList.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell", for: indexPath) as! MyListTableViewCell
        //if tableView.section == 0 {
            let artikel = myList[indexPath.row]
            
            cell.artikelName.text = artikel.artikelName
            cell.artikelQuantityTF.text = artikel.quantity
            
            if let text = cell.artikelQuantityTF.text, !text.isEmpty {
                cell.quantityLabel.isHidden = false
                cell.quantityLabel.text = cell.artikelQuantityTF.text
                cell.artikelQuantityTF.isHidden = true
            } else {
                cell.quantityLabel.text = ""
                cell.quantityLabel.isHidden = true
                cell.artikelQuantityTF.isHidden = false
                
            }
            
            cell.artikel = artikel
            if let artikelImage = artikel.artikelImage {
                cell.artikelImage.image = UIImage(data: artikelImage)
            } else {
                cell.artikelImage.image = UIImage(systemName: "photo.artframe")
            }
        //} else {
            
            
       // }
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let artikelToDelete = self.myList[indexPath.row]
            myList.remove(at: indexPath.row)
            artikelToDelete.isChecked = false
            artikelToDelete.quantity = ""
            tableView.deleteRows(at: [indexPath], with: .fade)
            appDelegate.saveContext()
            
        } else if editingStyle == .insert {
            
        }
    }

}
