//
//  CollectionViewCell.swift
//  Number Game
//
//  Created by Suresh Kumar on 20/11/18.
//  Copyright © 2018 Suresh Kumar. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let collectionViewCellReuseIdenitifier = "CollectionViewCellReuseIdentifier"
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    func setupView(number:Int,isBigNumber:Bool,isVisible:Bool){
        self.numberLabel.text = String(describing:number)
        self.numberLabel.layer.masksToBounds = true
        self.setBackgroundColor(isBigNumber: isBigNumber)
        if(isVisible){
            self.numberLabel.textColor = UIColor.white
        }
    }
    
    func setBackgroundColor(isBigNumber:Bool){
        if(isBigNumber){
            self.numberLabel.backgroundColor = Theme.bigNumberColor()
            self.numberLabel.textColor = Theme.bigNumberColor()
        }else{
            self.numberLabel.backgroundColor = Theme.smallNumberColor()
            self.numberLabel.textColor = Theme.smallNumberColor()
        }
    }
    
}
