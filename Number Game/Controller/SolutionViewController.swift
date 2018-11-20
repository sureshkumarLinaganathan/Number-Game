//
//  SolutionViewController.swift
//  Number Game
//
//  Created by Natarajan on 21/11/18.
//  Copyright © 2018 Suresh Kumar. All rights reserved.
//

import UIKit

let SOLUTION_VIEWCONTROLLER_SEGUE = "SolutionControllerSegue"

class SolutionViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    var selectdNumber:Array<Int> = []
    var timerValue:Int = 30
    var timer:Timer?
    var randomNumber:Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.randomNumberGenerator()
        self.setupView()
        self.setTimer()
    }
    
    func setupView(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(setTimerValue) , userInfo:nil, repeats:true)
    }
    
    func randomNumberGenerator(){
        
        let numberOperations = Int.random(in: 2...4)
        var count:Int = 1
        while count<=numberOperations {
            let operationChoise = Int.random(in:1...4)
            self.randomNumberCalculation(choice: operationChoise)
            count = count+1
        }
    }
    
    func randomNumberCalculation(choice:Int){
        let firstNumber:Int = self.selectdNumber[Int.random(in:0..<selectdNumber.count)]
        selectdNumber.remove(at:selectdNumber.firstIndex(of:firstNumber)!)
        let secondNumber:Int = self.selectdNumber[Int.random(in:0..<selectdNumber.count)]
        selectdNumber.remove(at:selectdNumber.firstIndex(of:secondNumber)!)
        if choice == 1{
            randomNumber = randomNumber + firstNumber+secondNumber
        }else if (choice == 2){
            randomNumber = randomNumber-(firstNumber-secondNumber)
        }else if(choice == 3){
            if randomNumber == 0{
                randomNumber = 1
            }
            randomNumber = randomNumber*(firstNumber*secondNumber)
        }else {
            if randomNumber == 0{
                randomNumber = 1
            }
            randomNumber = randomNumber/(firstNumber/secondNumber)
        }
        if(randomNumber<0){
            randomNumber = 0
        }
        print(randomNumber);
    }
    
    
    
    @objc func setTimerValue(){
        self.timerLabel.text = String(timerValue)
        self.timerValue = self.timerValue - 1;
        if(self.timerValue == 0){
            self.timerValue = 30;
            self.timer?.invalidate()
            showAlert()
        }
    }
    
    func showAlert(){
        let alert = UIAlertController.init(title:"", message:"Time up!", preferredStyle:.alert)
        let okAction = UIAlertAction.init(title:"Show", style:.default) { (action) in
            
        }
        alert.addAction(okAction)
        self.present(alert, animated:true, completion:nil)
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
}
