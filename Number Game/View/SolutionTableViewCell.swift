//
//  SolutionTableViewCell.swift
//  Number Game
//
//  Created by Suresh Kumar Linganathan on 22/11/18.
//  Copyright © 2018 Suresh Kumar. All rights reserved.
//

import UIKit

let SOLUTION_TABLE_VIEW_CELL_REUSE_IDENTIFIER = "SolutionTableViewCellReuseIdentifier"

class SolutionTableViewCell: UITableViewCell {
    @IBOutlet weak var answerLabel: UILabel!
    
    func setupView(answerStr:String){
        self.answerLabel.text = answerStr
    }
}
