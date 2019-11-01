//
//  SelectObjectController.swift
//  Student Management System
//
//  Created by Nhan Cao on 10/18/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
import CoreData

class SelectObjectController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var managedObjectContext: NSManagedObjectContext? = nil
    var callerController : DetailViewController? = nil
    
    var object : NSManagedObject? = nil
    
    var objectType = DataModel.ObjectType.student {
        didSet {
            if tableView != nil {
                tableView.reloadData()
                selectIncludedObjects()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.allowsMultipleSelection = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectIncludedObjects()
    }
    
    @IBAction func saveSelection(_ sender: Any) {
        if callerController != nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                //            self.dismiss(animated: true, completion: nil)
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            
            
            let key = DataModel.relation(of: callerController!.objectType)
            var selectedObject = [NSManagedObject]()
            let selectedIndexPaths = tableView.indexPathsForSelectedRows
            for indexPath in selectedIndexPaths ?? [] {
                selectedObject += [fetchedResultsController.object(at: indexPath)]
            }
            
            object?.setValue(NSOrderedSet(array: selectedObject), forKey: key)
            
            // Save the context.
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            callerController!.passData()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelSelection(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Table View
    
    func selectIncludedObjects() {
        for cell in tableView.visibleCells {
            let indexPath = tableView.indexPath(for: cell)!
            let thisObject = fetchedResultsController.object(at: indexPath)
            
            if callerController != nil && object != nil {
                let key = DataModel.relation(of: objectType)
                if let list = ((thisObject.value(forKey: key) as? NSOrderedSet)?.array as? [NSManagedObject]) {
                    if list.contains(object!) {
                        print("YAY")
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
                    }
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let thisObject = fetchedResultsController.object(at: indexPath)
        configureCell(cell, with: thisObject)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, with object: NSManagedObject) {
        cell.textLabel!.text = object.description
    }
    
    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        switch objectType {
        case .student:
            fetchData(model: Student())
        case .professor:
            fetchData(model: Professor())
        case .course:
            fetchData(model: Course())
        }
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    private func fetchData<T: NSManagedObject>(model: T) {
        let fetchRequest = T.fetchRequest() as! NSFetchRequest<T>

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "descriptionID", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = (aFetchedResultsController as! NSFetchedResultsController<NSManagedObject>)
    }
    
    var _fetchedResultsController: NSFetchedResultsController<NSManagedObject>? = nil

}

extension DataModel {
    static func relation(of type: DataModel.ObjectType) -> String{
        var str = ""
        switch type {
        case .student:
            str = "enrolledIn"
        case .professor:
            str = "instruct"
        case .course:
            str = "enrolledBy"
        }
        return str
    }
}
