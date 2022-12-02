//
//  WelcomeScreen.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 01.12.22.
//

import UIKit

class WelcomeScreen: UIViewController {

    @IBOutlet weak var listLbl: UILabel!
    @IBOutlet weak var menuLbl: UILabel!
    @IBOutlet weak var recipeLbl: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLabel()
        self.listLbl.isHidden = true
        self.menuLbl.isHidden = true
        self.recipeLbl.isHidden = true
        self.button.isHidden = true
        
        self.button.tintColor = UIColor.systemMint
      
    }

    func showLabel() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.listLbl.isHidden = false
                }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                    self.menuLbl.isHidden = false
                }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
                    self.recipeLbl.isHidden = false
                }
        DispatchQueue.main.asyncAfter(deadline: .now() + 11) {
                    self.button.isHidden = false
                }
    }


}
