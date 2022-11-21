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
    
    var searchArtikel: String? = nil
    
    lazy var fetchResultsController: NSFetchedResultsController<Artikel> = {
        let request: NSFetchRequest<Artikel> = Artikel.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "category.categoryName", ascending: true), NSSortDescriptor(key: "artikelName", ascending: true)]
        let resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "category.categoryName", cacheName: nil)
        do {
            try resultsController.performFetch()
        } catch {
            print(error)
        }
        
        return resultsController
    
    }()
    
    //gecheckte Artikeln in einem Array speichern
    var isSelectedItems = [Artikel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        // mehrere auswahl Möglichkeiten werden erlaubt
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appDelegate.saveContext()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }

    @IBAction func doneBtnTapped(_ sender: UIBarButtonItem) {
        
    }
    
    
}

extension HomeScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return category.count
        return fetchResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return category[section].categoryName
        return fetchResultsController.sections![section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return category[section].artikel?.count ?? 0
        return fetchResultsController.sections![section].numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ArtikelTableViewCell
        
        let artikel = fetchResultsController.object(at: indexPath)
        
            cell.artikelName.text = artikel.artikelName
          
//        if artikel.artikelName == searchArtikel {
//            cell.backgroundColor = UIColor.gray
//        }
            
            if let artikelImage = artikel.artikelImage {
                
                cell.artikelImage.image = UIImage(data: artikelImage)
                
            } else {
                cell.artikelImage.image = UIImage(systemName: "photo.artframe")
                
            }
        
        if artikel.isChecked == false {
            cell.checkbox.image = UIImage(systemName: "checkmark.seal")
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
            let artikelToDelete = fetchResultsController.object(at: indexPath)
            appDelegate.persistentContainer.viewContext.delete(artikelToDelete)
            appDelegate.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ArtikelTableViewCell
        
        let artikel = fetchResultsController.object(at: indexPath)
        
        artikel.isChecked = !artikel.isChecked
        
        if artikel.isChecked {
            cell.checkbox.image = UIImage(systemName: "checkmark.seal.fill")
        } else {
            cell.checkbox.image = UIImage(systemName: "checkmark.seal")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
}

extension HomeScreenVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchArtikel = searchController.searchBar.text, searchArtikel.count > 0 {
            self.searchArtikel = searchArtikel
            
            fetchResultsController.fetchRequest.predicate = NSPredicate(format: "artikelName Contains[c] %@", searchArtikel)
            
        } else {
            self.searchArtikel = nil
            fetchResultsController.fetchRequest.predicate = nil
        }
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
}

