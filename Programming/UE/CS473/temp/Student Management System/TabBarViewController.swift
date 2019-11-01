//
//  TabBarViewController.swift
//  Student Management System
//
//  Created by Nhan Cao on 10/13/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
//import CoreData

class TabBarViewController: UITabBarController {
    
    // MARK: Variables
    var objectType : DataModel.ObjectType {
        return (self.selectedViewController as? MasterViewController)?.objectType ?? .student
    }
    
    // MARK: Set up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        setUpBarButtonItems()
        
        let tabBarTitles = ["Students", "Professor", "Courses"]
        let tabBarImages = ["person.fill", "person.crop.square", "book"]
        
        self.tabBar.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        for i in 0..<3 {
            let barItem = self.tabBar.items?[i]
            barItem?.title = tabBarTitles[i]
            barItem?.image = UIImage(systemName: tabBarImages[i])
            
            (self.viewControllers?[i] as? MasterViewController)?.objectType = DataModel.ObjectType.all[i]
        }
    }
    
    private func setUpBarButtonItems() {
        let editButton = editButtonItem
        editButtonItem.action = #selector(switchEditMode(_:))
        editButtonItem.target = self
        navigationItem.leftBarButtonItem = editButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentCreateObjectView(_:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    // MARK: Functional features
    @objc private func presentCreateObjectView(_ sender: Any) {
        turnOffEditMode()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyBoard.instantiateViewController(withIdentifier: "AddNewObjectViewController") as! AddObjectViewController
        newController.objectType = self.objectType
        
        self.present(newController, animated: true, completion: nil)
    }
    
    @objc private func switchEditMode(_ sender: Any) {
        var buttonTitle = "Edit"
        var setEditting = false
        if navigationItem.leftBarButtonItem?.title == "Edit" {
            buttonTitle = "Done"
            setEditting = true
        }
        
        navigationItem.leftBarButtonItem?.title = buttonTitle
        self.selectedViewController?.isEditing = setEditting
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        turnOffEditMode()
    }
    
    private func turnOffEditMode() {
        navigationItem.leftBarButtonItem?.title = "Edit"
        for view in self.viewControllers ?? [] {
            (view as? MasterViewController)?.isEditing = false
        }
    }
}
