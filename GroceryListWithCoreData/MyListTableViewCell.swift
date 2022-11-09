//
//  MyListTableViewCell.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 21.10.22.
//

import UIKit

class MyListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artikelImage: UIImageView!
    @IBOutlet weak var artikelName: UILabel!
    @IBOutlet weak var artikelQuantityTF: UITextField!
    @IBOutlet weak var artikelQuantityLabel: UILabel!
    @IBOutlet weak var unit: UIPickerView!
    @IBOutlet weak var unitLabel: UILabel!
    
    var pickerData = ["Kg", "Gr","Stück", "Liter", "Packung"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pickerData = Array<String>()
        self.unit.delegate = self
        self.unit.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}

extension MyListTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
  
    
}
