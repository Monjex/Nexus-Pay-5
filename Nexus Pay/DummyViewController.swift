//
//  DummyViewController.swift
//  Nexus Pay
//
//  Created by TGPL-MACMINI-66 on 04/06/24.
//

import UIKit

class DummyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var dummyTblView: UITableView!
    
    @IBOutlet var checkBoxBtn: UIButton!
    
    // Variable to keep track of the checkbox state
        var isCheckBoxSelected: Bool = false {
            didSet {
                // Save main checkbox state to UserDefaults
                UserDefaults.standard.set(isCheckBoxSelected, forKey: "isCheckBoxSelected")
            }
        }
        
        // Array to keep track of each cell's checkbox state
        var cellCheckStates: [Bool] = Array(repeating: false, count: 10) {
            didSet {
                // Save cell check states to UserDefaults
                UserDefaults.standard.set(cellCheckStates, forKey: "cellCheckStates")
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load the states from UserDefaults
                if let savedCheckStates = UserDefaults.standard.array(forKey: "cellCheckStates") as? [Bool] {
                    cellCheckStates = savedCheckStates
                }
                
                isCheckBoxSelected = UserDefaults.standard.bool(forKey: "isCheckBoxSelected")
                
                // Initialize the main checkbox button state
                updateMainCheckBoxState()
        
        dummyTblView.delegate = self
        dummyTblView.dataSource = self
        
        dummyTblView.register(DummyTVC.loadNib(), forCellReuseIdentifier: "DummyTVC")
        
    }
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
        
//        // Toggle the main checkbox state
//                isCheckBoxSelected.toggle()
//                
//                // Update the main checkbox button image
//                let mainImageName = isCheckBoxSelected ? "CheckBox" : "BlankBox"
//                checkBoxBtn.setImage(UIImage(named: mainImageName), for: .normal)
//                
//                // Update all cell checkbox states
//                cellCheckStates = Array(repeating: isCheckBoxSelected, count: cellCheckStates.count)
//                
//                // Reload the table view to update cell button images
//                dummyTblView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCheckStates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DummyTVC", for: indexPath) as! DummyTVC
              
              // Update the cell button image based on the checkbox state
              let cellImageName = cellCheckStates[indexPath.row] ? "CheckBox" : "BlankBox"
              cell.cellBtn.setImage(UIImage(named: cellImageName), for: .normal)
              
              // Add target action for cell button
              cell.cellBtn.tag = indexPath.row
              cell.cellBtn.addTarget(self, action: #selector(cellCheckBoxAction(_:)), for: .touchUpInside)
              
              return cell
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    @objc func cellCheckBoxAction(_ sender: UIButton) {
            // Toggle the state of the cell button
            let index = sender.tag
            cellCheckStates[index].toggle()
            
            // Update the cell button image
            let cellImageName = cellCheckStates[index] ? "CheckBox" : "BlankBox"
            sender.setImage(UIImage(named: cellImageName), for: .normal)
            
            // Update the main checkbox button image based on all cell states
            updateMainCheckBoxState()
        }
        
        func updateMainCheckBoxState() {
            // Check if all cell checkboxes are selected
            let allSelected = cellCheckStates.allSatisfy { $0 }
            
            // Update the main checkbox button image
            let mainImageName = allSelected ? "CheckBox" : "BlankBox"
            checkBoxBtn.setImage(UIImage(named: mainImageName), for: .normal)
            
            // Update the main checkbox state
            isCheckBoxSelected = allSelected
        }
    

}
