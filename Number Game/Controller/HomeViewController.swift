//
//  ViewController.swift
//  Number Game
//
//  Created by Suresh Kumar on 20/11/18.
//  Copyright © 2018 Suresh Kumar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var randomNumberGenerateButton: UIButton!
    let ITEM_COUNT = 24
    let NUMBER_OF_ITEMS_ROW:CGFloat = 5
    let MAX_LIMT = 6
    
    var suffeldArray:Array<Int> = []
    var selectedIndex:Array<Int> = []
    var selectedNumber:Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults:UserDefaults = UserDefaults.standard;
        userDefaults.set(0, forKey: "score")
        userDefaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.setupDataSourceForGame()
        self.setupView()
    }
    func setupView(){
        self.randomNumberGenerateButton.layer.cornerRadius = self.randomNumberGenerateButton.frame.width/2;
        self.randomNumberGenerateButton.backgroundColor = UIColor.red;
        self.randomNumberGenerateButton.isHidden = true
    }
    func setupDataSourceForGame(){
        let numbers = [1,2,3,4,5,6,25,7,8,100,9,10,75,1,2,3,4,50,5,6,7,8,9,10]
        suffeldArray = numbers.shuffled()
        self.selectedNumber = []
        self.selectedIndex = []
        self.collectionView.reloadData()
    }
    func isBigNumber(number:Int)->Bool{
        if((number == 25)||(number == 50)||(number == 75)||(number == 100)){
            return true
        }
        return false
    }
    
    func isVisibleItem(indexPath:Int)->Bool{
        return (self.selectedIndex.contains(indexPath))
    }
    
    
    @IBAction func randomNumberGeneratorButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier:SOLUTION_VIEWCONTROLLER_SEGUE, sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == SOLUTION_VIEWCONTROLLER_SEGUE){
            let controller:SolutionViewController = segue.destination as! SolutionViewController
            controller.selectdNumber = self.selectedNumber
        }
    }
    func isNeedShowRandomGenerateButton(){
        if(self.selectedNumber.count == MAX_LIMT){
            self.randomNumberGenerateButton.isHidden = false
        }
    }
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ITEM_COUNT
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:CollectionViewCell.collectionViewCellReuseIdenitifier, for:indexPath) as! CollectionViewCell
        let number = suffeldArray[indexPath.row]
        let isbigNumber:Bool = self.isBigNumber(number:number)
        cell.setupView(number:number, isBigNumber:isbigNumber,isVisible:self.isVisibleItem(indexPath:indexPath.row))
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        let height = size.width/NUMBER_OF_ITEMS_ROW
        let width = size.width/NUMBER_OF_ITEMS_ROW
        return CGSize(width:height, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNumber = self.suffeldArray[indexPath.row];
        if((!selectedIndex.contains(indexPath.row))&&(self.selectedIndex.count<6)){
            self.selectedIndex.append(indexPath.row)
            self.selectedNumber.append(selectedNumber);
            self.collectionView.reloadItems(at: [indexPath])
        }
        self.isNeedShowRandomGenerateButton()
    }
    
}

