//
//  LeaveBalanceVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 18/04/23.
//

import UIKit

class LeaveBalanceVC: UIViewController {
    
    
    @IBOutlet weak var leaveBalanceColView: UICollectionView!
    
    var selectedIndex = Int ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        leaveBalanceColView.register(LeaveBalanceCVC.loadNib(), forCellWithReuseIdentifier: "LeaveBalanceCVC")
    }
    
    
    func moveCollectionToFrame(contentOffset : CGFloat) {

            let frame: CGRect = CGRect(x : contentOffset ,y : self.leaveBalanceColView.contentOffset.y ,width : self.leaveBalanceColView.frame.width,height : self.leaveBalanceColView.frame.height)
            self.leaveBalanceColView.scrollRectToVisible(frame, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func leftArrowAction(_ sender: Any) {
        let collectionBounds = self.leaveBalanceColView.bounds
                let contentOffset = CGFloat(floor(self.leaveBalanceColView.contentOffset.x - collectionBounds.size.width))
                self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    
    @IBAction func rightArrowAction(_ sender: Any) {
        let collectionBounds = self.leaveBalanceColView.bounds
                let contentOffset = CGFloat(floor(self.leaveBalanceColView.contentOffset.x + collectionBounds.size.width))
                self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
}

extension LeaveBalanceVC: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaveBalanceCVC", for: indexPath) as! LeaveBalanceCVC
        
        if selectedIndex == indexPath.row
            {
                cell.mainView.backgroundColor = UIColor.appBlue
                cell.typeLbl.textColor = UIColor.white
            }
            else
            {
                cell.mainView.backgroundColor = UIColor.white
                cell.typeLbl.textColor = UIColor.appBlue
            }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: (collectionView.frame.width) / 2.1, height: 80)
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedIndex = indexPath.row

            self.leaveBalanceColView.reloadData()
        
    }
    
}
