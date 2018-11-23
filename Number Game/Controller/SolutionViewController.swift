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
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var randomNumberLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calculatorView: UIView!
    
    let NUMBER_OF_OPERRATIONS = 4
    let RANDOM_NUMBER_MAX_LIMIT = 1000
    let RANDOM_NUMBR_MIN_LIMIT = 0
    
    
    
    var selectdNumber:Array<Int> = []
    var timerValue:Int = 30
    var timer:Timer?
    var randomNumber:Int = 0
    var solutionArray:Array<String> = []
    var caculatorDatasource:Array<String> = []
    var numberArray:Array<Int> = []
    var selectedIndex:Array<Int> = []
    var actionCount:Int = 0
    var firstNumber:Int = 0
    var secondNumber:Int = 0
    var operationValue:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCalculatorViewDatasource()
        self.randomNumberGenerator()
        self.setupView()
        self.textField?.text = ""
        self.setTimer()
    }
    func setupView(){
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.isHidden = true;
        self.replayButton.isHidden = true;
        self.replayButton.layer.cornerRadius = self.replayButton.frame.height/2
        self.tableView.tableFooterView = UIView(frame:.zero)
    }
    
    func setupCalculatorViewDatasource(){
        for value in self.selectdNumber{
            self.numberArray.append(value)
            self.caculatorDatasource.append(String(value))
        }
        self.caculatorDatasource.append("+")
        self.caculatorDatasource.append("-")
        self.caculatorDatasource.append("*")
        self.caculatorDatasource.append("/")
        self.caculatorDatasource.append("RESET")
        self.collectionView.reloadData()
    }
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval:1.0, target:self, selector:#selector(setTimerValue) , userInfo:nil, repeats:true)
    }
    
    
    @objc func setTimerValue(){
        self.timerLabel.text = String(timerValue)
        self.timerValue = self.timerValue - 1;
        if(self.timerValue == -1){
            self.timer?.invalidate()
            DispatchQueue.main.async {
                let score = self.calculateScore(total: self.firstNumber)
                self.showScore(title:"Time up!", buttonTitle:"Show", isWin:false,score:score)
            }
        }
    }
    
    func showScore(title:String,buttonTitle:String,isWin:Bool,score:Int){
        let msg = "Your Total Score is "+String(score)
        let alert = UIAlertController.init(title:title, message:msg, preferredStyle:.alert)
        let okAction = UIAlertAction.init(title:buttonTitle, style:.default) { (action) in
            if(isWin){
                self.navigationController?.popViewController(animated:true)
            }else{
                self.showSolutionView()
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated:true, completion:nil)
    }
    
    func showSolutionView(){
        self.tableView.isHidden = false
        self.replayButton.isHidden = false
        self.calculatorView.isHidden = true
        self.tableView.reloadData()
    }
    func calculateScore(total:Int)->Int{
        let userDefaults:UserDefaults = UserDefaults.standard
        var oldScore:Int = userDefaults.value(forKey:"score") as! Int;
        let ans = self.subtractValue(firstNumber:total, secondNumber:randomNumber)
        if(ans == 0){
            oldScore = oldScore+10
        }else if(ans <= 5){
            oldScore = oldScore+7
        }else if(ans<=10){
            oldScore = oldScore+5;
        }
        userDefaults.set(oldScore, forKey:"score")
        return oldScore
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    @IBAction func replyButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
}

extension SolutionViewController{
    func randomNumberGenerator(){
        let numberOperations = Int.random(in: 1..<NUMBER_OF_OPERRATIONS)
        var count:Int = 1
        while count<=numberOperations {
            let operationChoise = Int.random(in:1...NUMBER_OF_OPERRATIONS)
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
            self.createDatatSourceForSolutionView(firstNumber:firstNumber, secondNumber: secondNumber, total:sum,choice:"+")
            
        case 2:
            var sub = self.subtractValue(firstNumber:firstNumber, secondNumber:secondNumber)
            sub = self.subtractValue(firstNumber:sub, secondNumber:randomNumber)
            self.createDatatSourceForSolutionView(firstNumber:firstNumber, secondNumber:secondNumber, total:sub, choice:"-")
            
        case 3:
            var ans = firstNumber * secondNumber;
            ans = randomNumber == 0 ? 1*ans :ans*randomNumber
            self.createDatatSourceForSolutionView(firstNumber:firstNumber, secondNumber: secondNumber, total:ans,choice:"*")
            
        default:
            var ans = self.findQuotient(firstNumber:firstNumber, secondNumber:secondNumber)
            randomNumber = randomNumber == 0 ? 1:randomNumber
            ans = self.findQuotient(firstNumber:randomNumber, secondNumber:ans)
            self.createDatatSourceForSolutionView(firstNumber:firstNumber, secondNumber:secondNumber, total:ans, choice:"/")
        }
    }
    
    func createDatatSourceForSolutionView(firstNumber:Int,secondNumber:Int,total:Int,choice:String){
        if(total<RANDOM_NUMBER_MAX_LIMIT&&total>RANDOM_NUMBR_MIN_LIMIT){
            var str:String;
            if(firstNumber>secondNumber){
                str = self.createDataSourceForsolutionTableview(firsNumber:firstNumber, secondNumber:secondNumber, randomNumber:randomNumber, choice:choice)
            }else{
                str = self.createDataSourceForsolutionTableview(firsNumber:secondNumber, secondNumber:firstNumber, randomNumber:randomNumber, choice:choice)
            }
            randomNumber = total
            str = str + "=" + String(randomNumber)
            self.solutionArray.append(str)
            
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

extension SolutionViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.caculatorDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CalculatorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:CALCULATOR_COLLECTION_VIEW_CELL_REUSE_IDENTIFIER, for: indexPath) as! CalculatorCollectionViewCell
        let str = self.caculatorDatasource[indexPath.row]
        let isEnabled:Bool = self.selectedIndex.contains(indexPath.row)
        cell.setupView(value: str, isEnabled:!isEnabled)
        cell.delegate = self as CalculatorCollectionViewCellDelegate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        let height = size.width/4
        let width = size.width/4
        return CGSize(width:height, height: width)
    }
}

extension SolutionViewController:CalculatorCollectionViewCellDelegate{
    
    func calculatorCollectionViewCell(cell: CalculatorCollectionViewCell, didTapped value: String) {
        let index = self.collectionView.indexPath(for:cell)
        self.performOperation(index:(index?.row)!)
        self.collectionView.reloadItems(at: [index!])
    }
    
    func performOperation(index:Int){
        if((index<6)&&((self.actionCount == 0)||(self.actionCount == 2))){
            self.selectedIndex.append(index)
            if((self.firstNumber == 0)&&(actionCount == 0)){
                self.firstNumber = self.numberArray[index]
            }else{
                self.secondNumber = self.numberArray[index]
            }
            self.setValueForTextField(index:index)
        }else if((index>5)&&(index<10 )&&(self.actionCount == 1)){
            operationValue = self.caculatorDatasource[index];
            self.setValueForTextField(index:(index))
        }else if(index == 10){
            self.reset()
        }
        
    }
    
    func setValueForTextField(index:Int){
        actionCount = actionCount+1
        let value = self.caculatorDatasource[index]
        self.textField.text = (self.textField?.text)!+value
        if((actionCount == 3)&&(secondNumber>0)){
            self.doCalculation(firstNumber:firstNumber, secondNumber:secondNumber, operationType:operationValue)
        }
    }
    func doCalculation(firstNumber:Int,secondNumber:Int,operationType:String){
        var total = 0
        switch operationType {
        case "+":
            total = firstNumber+secondNumber
            self.textField.text = String(total)
        case "-":
            total = (firstNumber-secondNumber)
            self.textField.text = String(total)
        case "*":
            total = firstNumber*secondNumber
            self.textField.text = String(total)
        default:
            total = (firstNumber/secondNumber)
            self.textField.text = String(total)
        }
        self.checkIsPlayerReachedTraget(total:total)
        self.resetOperationValues()
        self.actionCount = 1
        self.firstNumber = total
    }
    
    func checkIsPlayerReachedTraget(total:Int){
        if( self.randomNumber == total){
            self.timer?.invalidate()
            let score = self.calculateScore(total:total)
            self.showScore(title:"You Win!", buttonTitle:"New Round", isWin:true, score:score)
            
        }
    }
    func reset(){
        self.textField.text = ""
        self.selectedIndex.removeAll()
        self.collectionView.reloadData()
        self.resetOperationValues()
    }
    func resetOperationValues(){
        self.firstNumber = 0
        self.secondNumber = 0
        self.operationValue = ""
        self.actionCount = 0
    }
}





