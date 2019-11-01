//
//  DetailViewController.swift
//  Student Management System
//
//  Created by Nhan Cao on 10/2/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: GenericInfoViewController {

    @IBOutlet weak var objectInfoView: ObjectInfoView!
    
    var objectType = DataModel.ObjectType.student {
        didSet {
            if objectInfoView != nil {
                objectInfoView.objectType = self.objectType
            }
        }
    }
    
    var object : NSManagedObject? = nil {
        didSet {
            passData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView() {
        // Update the user interface for the detail item.

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(switchEditMode(_:)))
        navigationItem.title = "Info"
        
        objectInfoView.viewMode = .view
        objectInfoView.objectType = self.objectType
        objectInfoView.parent = self
        passData()
    }
    
    // MARK: Functional Feature
    @objc private func switchEditMode(_ sender: Any) {
        var buttonTitle : String
        
        if navigationItem.rightBarButtonItem?.title == "Edit" {
            // Just hit [Edit]
            objectInfoView.viewMode = .edit
            buttonTitle = "Done"
        } else {
            // Just hit [Done]
            save(data: objectInfoView.getInputedData(), to: object)
            
            objectInfoView.viewMode = .view
            buttonTitle = "Edit"
        }
        navigationItem.rightBarButtonItem?.title = buttonTitle
    }
    
    func passData() {
        if objectInfoView != nil {
            var data = [String:Any]()
            let attributesByName = object?.entity.attributesByName ?? [String:Any]()
            let relationshipsByName = object?.entity.relationshipsByName ?? [String:Any]()
            
            for (key, _) in attributesByName {
                data[key] = object?.value(forKey: key)
            }
            
            for (key, _) in relationshipsByName {
                data[key] = (object?.value(forKey: key) as? NSOrderedSet)?.array
            }
        
            objectInfoView.objectData = data
        }
    }
    
    override func updateProfile(with image: UIImage) {
        objectInfoView.profileImageView.image = image
        objectInfoView.didSetImage = true
    }
    
    override func presentObjectPicker(with objectType: DataModel.ObjectType) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyBoard.instantiateViewController(withIdentifier: "SelectObjectController") as! SelectObjectController

        newController.callerController = self
        newController.objectType = objectType
        
        newController.managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        newController.object = self.object
        
        self.present(newController, animated: true, completion: nil)
    }


}

