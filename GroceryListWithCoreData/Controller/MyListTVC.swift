//
//  MyListTVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 21.10.22.
//

import UIKit
import CoreData

class MyListTVC: UITableViewController {
    
    
    //var list = [Category]()
    var myList = [Artikel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchCategory()
    }
    
//    func fetchCategory() {
//
//        do {
//           let alleArtikel = try appDelegate.persistentContainer.viewContext.fetch(Artikel.fetchRequest())
//            for artikel in alleArtikel {
//                if artikel.isChecked {
//                    myList.append(artikel)
//                }
//            }
//        } catch {
//            print("Fehler")
//        }
//
//        tableView.reloadData()
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myList.isSelectedItems.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell", for: indexPath) as! MyListTableViewCell
       // var content = cell.defaultContentConfiguration()
        let artikel = myList.isSelectedItems[indexPath.row]
        
       if artikel.isChecked == true {
            
           cell.artikelName.text = artikel.artikelName
            
            if let artikelImage = artikel.artikelImage {
                
                cell.artikelImage.image = UIImage(data: artikelImage)
                
            } else {
                cell.artikelImage.image = UIImage(systemName: "photo.artframe")
            }
            //cell.contentConfiguration = content
      }
    
        
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

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

}
