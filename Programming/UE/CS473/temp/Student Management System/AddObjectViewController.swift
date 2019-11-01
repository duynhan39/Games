//
//  CreateNewObjectViewController.swift
//  Student Management System
//
//  Created by Nhan Cao on 10/12/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
import CoreData

class AddObjectViewController: GenericInfoViewController {
    
    // MARK: Valiables
    @IBOutlet weak var objectInfoView: ObjectInfoView!
    
    var objectType = DataModel.ObjectType.student
    
    // MARK: Set up
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        objectInfoView.objectType = self.objectType
        self.isModalInPresentation = true
        objectInfoView.parent = self
    }
    
    // MARK: Functional Features
    @IBAction func saveInfo(_ sender: Any) {
        switch objectType {
        case .student:
            createNewObject(model: Student())
        case .professor:
            createNewObject(model: Professor())
        case .course:
            createNewObject(model: Course())
        }
        
        goBackToPreviousView()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        goBackToPreviousView()
    }
    
    override func updateProfile(with image: UIImage) {
        objectInfoView.profileImageView.image = image
        objectInfoView.didSetImage = true
    }

    private func createNewObject<T: NSManagedObject>(model: T) {
        let template : T? = nil
        save(data: objectInfoView.getInputedData(), to: template)
    }
    
    private func goBackToPreviousView() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}





