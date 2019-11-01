//
//  InfoViewController.swift
//  Student Management System
//
//  Created by Nhan Cao on 10/17/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
import CoreData

class GenericInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePickerSourceType = UIImagePickerController.SourceType.camera
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showImagePickerOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.imagePickerSourceType = .camera
            self.presentImagePicker()
        }))
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.imagePickerSourceType = .photoLibrary
            self.presentImagePicker()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func presentImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        if imagePickerSourceType == .camera && UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
        } else if  UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerController.sourceType = .photoLibrary
        } else {
            // None available
            return
        }
    
        self.present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        updateProfile(with: image)
    }
    
    func updateProfile(with image: UIImage) {}
    
    func save<T: NSManagedObject>(data: [String:Any], to object: T?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let targetedObject : T = object ?? T(context: context)
        
        targetedObject.setValuesForKeys(data)
        targetedObject.setValue(targetedObject.description, forKey: "descriptionID")
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func presentObjectPicker(with objectType: DataModel.ObjectType) {}


}
