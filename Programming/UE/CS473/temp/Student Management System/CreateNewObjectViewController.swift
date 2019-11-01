//
//  CreateNewObjectViewController.swift
//  Student Management System
//
//  Created by Nhan Cao on 10/12/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit

class NewPersonViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet weak var attributeTable: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    
    
    var attributes = [String]()
    var objectType = DataModel.ObjectType.student {
        didSet {
            switch self.objectType {
            case .student:
                attributes = Array(Student.entity().attributesByName.keys)
            case .professor:
                attributes = Array(Professor.entity().attributesByName.keys)
            case .course:
                attributes = Array(Course.entity().attributesByName.keys)
            }
            refreshUI()
        }
    }
    

    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        attributeTable.dataSource = self
        objectType = DataModel.ObjectType.student
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshUI()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newInfoCell", for: indexPath) as! NewInfoCell
        
        cell.attributeLabel.text = attributes[indexPath.row]
        
        return cell
    }
    
    private func refreshUI() {
        self.loadViewIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        if attributeTable.numberOfRows(inSection: 0) > 0 {
            attributeTable.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
