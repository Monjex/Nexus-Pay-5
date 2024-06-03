//
//  PreviousRequestVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 13/04/23.
//

import UIKit
import IBAnimatable

class PreviousRequestVC: UIViewController {
    
    @IBOutlet weak var previousRequestTblView: UITableView!
    
    @IBOutlet weak var fromDateTxtFld: AnimatableTextField!

    @IBOutlet weak var shadowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        previousRequestTblView.register(UpcomingRequestTVC.loadNib(), forCellReuseIdentifier: "UpcomingRequestTVC")
        
        shadowView.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectTypeAction(_ sender: Any) {
    }
    
    
    @IBAction func selectStatusAction(_ sender: Any) {
    }
    
    
    @IBAction func clearFilterAction(_ sender: Any) {
    }
    
    
    @IBAction func closePopupAction(_ sender: Any) {
        shadowView.isHidden = true
    }
    
    
    @IBAction func cancelRequestAction(_ sender: Any) {
    }
    
    @objc func tappedOnStatusButton(_ sender: UIButton) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PreviousRequestDetailVC") as! PreviousRequestDetailVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    @objc func tappedOnEyeButton(_ sender: UIButton) {
        shadowView.isHidden = false
        
    }
    

}

extension PreviousRequestVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let Categoriescell : UpcomingRequestTVC = tableView.dequeueReusableCell(withIdentifier: "UpcomingRequestTVC", for: indexPath) as! UpcomingRequestTVC
        
        Categoriescell.selectionStyle = .none
        
        Categoriescell.statusBtn.tag = indexPath.row
        Categoriescell.statusBtn.addTarget(self, action: #selector(tappedOnStatusButton), for: .touchUpInside)
        
        Categoriescell.eyeBtn.tag = indexPath.row
        Categoriescell.eyeBtn.addTarget(self, action: #selector(tappedOnEyeButton), for: .touchUpInside)
            
        return Categoriescell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 48
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: nil)
        
        
    }
    
}
