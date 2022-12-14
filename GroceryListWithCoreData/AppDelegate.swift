//
//  AppDelegate.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.10.22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //hier holen wir den Link für das Programm TablePlus (um die Inhalte von CoreData zu sehen)
        print("#"+NSHomeDirectory())
        
        //hier prüfen wir ob die App erste Mal startet
        if UserDefaults.standard.object(forKey: "wurdeErsteMalGestarted") == nil {
            
            // wenn true ist dann wird die Kategorien erstellt
            let artikelCategorys = ["Obst", "Gemüse", "Milchprodukte", "Getreideprodukte", "Getränke", "Fleisch, Wurst, Fisch und Eier", "Extras"]
            
            let weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"]
            
            UserDefaults.standard.set(true, forKey: "wurdeErsteMalGestarted")
            
            //zu jeden Tag wird ein Index zugewiesen und in Coredata gespeichert
            for day in 0...6 {
                let coreDataWeekDays = WeeklyPlanner(context: context)
                coreDataWeekDays.indexOfDays = Int16(day)
                coreDataWeekDays.weekday = weekDays[day]
            }
            
            //artikelCategorys werden in CoreData gespeichert
            for name in artikelCategorys {
                let coreDataCategory = Category(context: context)
                coreDataCategory.categoryName = name
                
                
                let gemuese = ["Tomaten", "Gurken", "Avocado", "Brokkoli", "Paprika", "Kürbis"]
                let obst = ["Apfel", "Birne", "Bananen", "Pflaume", "Trauben", "Kiwi"]
                let milchProdukte = ["Milch", "Butter", "Käse", "Frischkäse", "Joghurt", "Kaffeesahne"]
                let getreideProdukte = ["Brot", "Brötchen", "Brezel", "Nudeln", "Reis", "Haferflocken"]
                let getränke = ["Saft", "Mineralwasser", "Limonade", "Apfelschorle", "Coca Cola"]
                let fleischWurstEier = ["Rindfleisch", "Geflügelfleisch", "Eier", "Fisch", "Salami", "Wurst"]
                let extras = ["Schokolade", "Chips", "Pistazien", "Cashewkerne" ]
                
                //mit diese funktion werden Artikeln in die Categorien hinzugefügt
                createArtikel(coreDataCategory: coreDataCategory, produkt: extras, artikelCategories: "Extras")
                createArtikel(coreDataCategory: coreDataCategory, produkt: milchProdukte, artikelCategories: "Milchprodukte")
                createArtikel(coreDataCategory: coreDataCategory, produkt: getreideProdukte, artikelCategories: "Getreideprodukte")
                createArtikel(coreDataCategory: coreDataCategory, produkt: getränke, artikelCategories: "Getränke")
                createArtikel(coreDataCategory: coreDataCategory, produkt: fleischWurstEier, artikelCategories: "Fleisch, Wurst, Fisch und Eier")
                createArtikel(coreDataCategory: coreDataCategory, produkt: gemuese, artikelCategories: "Gemüse")
                createArtikel(coreDataCategory: coreDataCategory, produkt: obst, artikelCategories: "Obst")
                
            }
            //speichert die Kategorien und die Artikeln in CoreData ab
            self.saveContext()
        }
        return true
    }
    
    ///Artikeln werden in einer Bestimmte Categorie hinzugefügt
    ///
    /// - Parameters:
    ///      - coreDataCategory: die Categorie in dem gespeichert werden soll
    ///      - produkt: ein Array die aus Artikeln besteht
    ///      - artikelCategories: um zu prüfen zu welche Kategorie gehört ein oder andere Artikel
    func createArtikel(coreDataCategory: Category, produkt: [String], artikelCategories: String) {
        
        if coreDataCategory.categoryName == artikelCategories {
            for artikelName in produkt {
                let artikelCD = Artikel(context: context)
                artikelCD.artikelName = artikelName
                artikelCD.category = coreDataCategory
                
                artikelCD.artikelImage = UIImage(named: artikelName)?.pngData()
            }
           
        }
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GroceryListWithCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
       let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

