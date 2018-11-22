//
//  CalculatorCollectionViewCell.swift
//  Number Game
//
//  Created by Suresh Kumar on 22/11/18.
//  Copyright © 2018 Suresh Kumar. All rights reserved.
//

import UIKit

let CALCULATOR_COLLECTION_VIEW_CELL_REUSE_IDENTIFIER = "CalculatorCollectionViewCellReuseIdentifier"

protocol CalculatorCollectionViewCellDelegate {
   
    func calculatorCollectionViewCell(cell:CalculatorCollectionViewCell,didTapped value:String)
}

class CalculatorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var numberButton: UIButton!
    var delegate:CalculatorCollectionViewCellDelegate?
    
    func setupView(value:String,isEnabled:Bool){
        self.numberButton.setTitle(value, for:.normal)
        self.numberButton.isEnabled = isEnabled
        if(!isEnabled){
        self.numberButton.setTitleColor(UIColor.gray, for:.normal)
        }else{
             self.numberButton.setTitleColor(UIColor.black, for:.normal)
        }
    }
    
    @IBAction func numberButtonTapped(_ sender: Any) {
        self.delegate?.calculatorCollectionViewCell(cell:self, didTapped:self.numberButton.currentTitle!)
    }
    
}
