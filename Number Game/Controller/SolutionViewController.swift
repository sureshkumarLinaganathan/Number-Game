//
//  SolutionViewController.swift
//  Number Game
//
//  Created by Suresh Kumar on 21/11/18.
//  Copyright © 2018 Suresh Kumar. All rights reserved.
//

import UIKit

let SOLUTION_VIEWCONTROLLER_SEGUE = "SolutionControllerSegue"

class SolutionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var randomNumberLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    
    var selectdNumber:Array<Int> = []
    var timerValue:Int = 30
    var timer:Timer?
    var randomNumber:Int = 0
    var solutionArray:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let choice = Int.random(in: 1...2)
        self.randomNumberCalculation(choice:choice);
        self.randomNumberGenerator()
        self.setupView()
        self.setTimer()
    }
    func setupView(){
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.isHidden = true;
        self.replayButton.isHidden = true;
    }
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(setTimerValue) , userInfo:nil, repeats:true)
    }
    
    func randomNumberGenerator(){
        
        let numberOperations = Int.random(in: 1..<3)
        var count:Int = 1
        while count<=numberOperations {
            let operationChoise = Int.random(in:1...4)
            self.randomNumberCalculation(choice: operationChoise)
            count = count+1
        }
        self.randomNumberLabel.text = String(randomNumber)
    }
    
    func randomNumberCalculation(choice:Int){
        let firstNumber:Int = self.selectdNumber[Int.random(in:0..<selectdNumber.count)]
        selectdNumber.remove(at:selectdNumber.firstIndex(of:firstNumber)!)
        let secondNumber:Int = self.selectdNumber[Int.random(in:0..<selectdNumber.count)]
        selectdNumber.remove(at:selectdNumber.firstIndex(of:secondNumber)!)
        switch choice {
        case 1:
            var sum = firstNumber+secondNumber
            sum = randomNumber+sum
            if(sum<1000&&sum>0){
                var str = self.createDataSourceForsolutionTableview(firsNumber:firstNumber, secondNumber:secondNumber, randomNumber:randomNumber, choice:"+")
                randomNumber = sum
                str = str + "=" + String(randomNumber)
                self.solutionArray.append(str)
            }
            
        case 2:
            var sub = self.subtractValue(firstNumber:firstNumber, secondNumber:secondNumber)
            sub = self.subtractValue(firstNumber:sub, secondNumber:randomNumber)
            if(sub<1000&&sub>0){
                var str:String;
                if(firstNumber>secondNumber){
                    str = self.createDataSourceForsolutionTableview(firsNumber:firstNumber, secondNumber:secondNumber, randomNumber:randomNumber, choice:"-")
                }else{
                    str = self.createDataSourceForsolutionTableview(firsNumber:secondNumber, secondNumber:firstNumber, randomNumber:randomNumber, choice:"-")
                }
                randomNumber = sub
                str = str + "=" + String(randomNumber)
                self.solutionArray.append(str)
                
            }
        case 3:
            var ans = firstNumber * secondNumber;
            randomNumber = randomNumber == 0 ? 1:randomNumber
            ans = ans*randomNumber
            randomNumber = (ans > 999 || ans<0) ? randomNumber:ans
            if(ans<1000&&ans>0){
                var str = self.createDataSourceForsolutionTableview(firsNumber:firstNumber, secondNumber:secondNumber, randomNumber:randomNumber, choice:"*")
                randomNumber = ans
                str = str + "=" + String(randomNumber)
                self.solutionArray.append(str)
                
            }
        default:
            var ans = self.findQuotient(firstNumber:firstNumber, secondNumber:secondNumber)
            randomNumber = randomNumber == 0 ? 1:randomNumber
            ans = self.findQuotient(firstNumber:randomNumber, secondNumber:ans)
            randomNumber = (ans > 999 || ans<0) ? randomNumber:ans
            if(ans<1000&&ans>0){
                var str:String;
                if(firstNumber>secondNumber){
                    str = self.createDataSourceForsolutionTableview(firsNumber:firstNumber, secondNumber:secondNumber, randomNumber:randomNumber, choice:"/")
                }else{
                    str = self.createDataSourceForsolutionTableview(firsNumber:secondNumber, secondNumber:firstNumber, randomNumber:randomNumber, choice:"/")
                }
                randomNumber = ans
                str = str + "=" + String(randomNumber)
                self.solutionArray.append(str)
                
            }
        }
    }
    
    func findQuotient(firstNumber:Int,secondNumber:Int)->Int{
        if(firstNumber>secondNumber){
            return firstNumber/secondNumber
        }else{
            return secondNumber/firstNumber
        }
    }
    func subtractValue(firstNumber:Int,secondNumber:Int)->Int{
        if(firstNumber>secondNumber){
            return firstNumber-secondNumber
        }else{
            return secondNumber-firstNumber
        }
    }
    
    func createDataSourceForsolutionTableview(firsNumber:Int,secondNumber:Int,randomNumber:Int,choice:String) ->String{
        var str = "("+String(firsNumber)+choice+String(secondNumber)+")";
        if(randomNumber>0){
            str = "("+String(randomNumber)+")"+choice+str
        }
        return str;
    }
    
    @objc func setTimerValue(){
        self.timerLabel.text = String(timerValue)
        self.timerValue = self.timerValue - 1;
        if(self.timerValue == -1){
            self.timerValue = 29;
            self.timer?.invalidate()
            DispatchQueue.main.async {
                self.showAlert()
            }
        }
    }
    
    func showAlert(){
        let alert = UIAlertController.init(title:"", message:"Time up!", preferredStyle:.alert)
        let okAction = UIAlertAction.init(title:"Show", style:.default) { (action) in
            self.tableView.isHidden = false;
            self.replayButton.isHidden = false;
            self.tableView.reloadData()
        }
        alert.addAction(okAction)
        self.present(alert, animated:true, completion:nil)
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    @IBAction func replyButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
}

extension SolutionViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solutionArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SolutionTableViewCell = tableView.dequeueReusableCell(withIdentifier:SOLUTION_TABLE_VIEW_CELL_REUSE_IDENTIFIER, for:indexPath) as! SolutionTableViewCell
        let str = self.solutionArray[indexPath.row]
        cell.setupView(answerStr:str)
        return cell
    }
}
