//
//  ViewController.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 18.10.22.
//

import UIKit
import Photos
import PhotosUI

class AddArtikelVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
 
    @IBOutlet weak var artikelTF: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var artikelImage: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    var selectedCategory: Category!
    var artikelCategory = [Category]()
    var artikel = [Artikel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("#"+NSHomeDirectory())
        artikelTF.delegate = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        }
    
    
    @IBAction func addImageButton(_ sender: UIButton) {
        
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = PHPickerFilter.any(of: [.images, .panoramas])
         let photoPicker = PHPickerViewController(configuration: config)
        photoPicker.delegate = self
        self.present(photoPicker, animated: true)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        fetchCategory()
        
    }
    
    func fetchCategory() {
        
        do {
            artikelCategory = try appDelegate.persistentContainer.viewContext.fetch(Category.fetchRequest())
        } catch {
            print("Fehler")
        }
       
        categoryPickerView.reloadAllComponents()
    }
    
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
        
        if let artikelName = artikelTF.text, artikelTF.text != "" {
            let artikel = Artikel(context: context)
            artikel.artikelName = artikelName
            let rowSelected = categoryPickerView.selectedRow(inComponent: 0)
            
            artikel.category = selectedCategory
            artikel.artikelImage = artikelImage.image?.pngData()
        }
    
        self.navigationController?.popViewController(animated: true)
        
        appDelegate.saveContext()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return artikelCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return artikelCategory[row].categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = artikelCategory[row]
     
    }
}

extension AddArtikelVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { proveiderReading, error in
                if let error = error {
                    print(error)
                    return
                }
                if let proveiderReading = proveiderReading {
                    let image = proveiderReading as! UIImage
                    DispatchQueue.main.async {
                        self.artikelImage.image = image
                    }
                }
            }
        }
    }
}

