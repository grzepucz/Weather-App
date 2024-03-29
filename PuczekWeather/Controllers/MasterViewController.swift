//
//  MasterViewController.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 31/10/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var detailViewController: CityDetailViewController? = nil
    var searchLocationViewController: SearchLocationViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    @IBOutlet weak var addButton: UIBarButtonItem!
    var managedObjects: [NSManagedObject]? = nil
    
    var dataProvider: DataProvider!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locations = [Coordinates]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        
        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchLocation(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? CityDetailViewController
        }
    }
    //
    //    @objc
    //    func searchLocation(_ sender: Any) {
    //        let controller = SearchLocationViewController()
    //        controller.addLocationDelegate = self
    //        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    //        controller.navigationItem.leftItemsSupplementBackButton = true
    //
    //        self.present(controller, animated: true, completion: nil)
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! CityDetailViewController
                controller.latitude = object.value(forKeyPath: "latitude") as? Double
                controller.longitude = object.value(forKeyPath: "longitude") as? Double
                controller.cityName = object.value(forKeyPath: "name") as? String
                controller.cellIndex = indexPath.row
                controller.cityDetailForecast = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        
        if segue.identifier == "searchLocation" {
            let controller = segue.destination  as! SearchLocationViewController
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.addLocationDelegate = self
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityShortTableViewCell
        let location = fetchedResultsController.object(at: indexPath)
        
        configureCell(cell, withLocation: location)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func configureCell(_ cell: CityShortTableViewCell, withLocation location: NSManagedObject) {
        
        cell.location!.text = location.value(forKeyPath: "name") as? String
        
        if ((location.value(forKeyPath: "currentTemperature")) != nil) {
            cell.temperature.text = (String((location.value(forKeyPath: "currentTemperature") as! Double))) + " C"
        }
        
        if (location.value(forKeyPath: "icon") != nil) {
            cell.icon.image = UIImage(named: (location.value(forKeyPath: "icon") as? String)! + ".png")
        }
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: "Localization")
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
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
    var _fetchedResultsController: NSFetchedResultsController<NSManagedObject>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)! as! CityShortTableViewCell, withLocation: anObject as! NSManagedObject)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)! as! CityShortTableViewCell, withLocation: anObject as! NSManagedObject)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    /*
     Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     */
    //    func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //         tableView.reloadData()
    //     }
    
    
}

extension MasterViewController: AddLocationDelegate, DataProviderDelegate {
    func didFinish(_ provider: DataProvider) {
        let context = self.fetchedResultsController.managedObjectContext
        let newPlace = NSEntityDescription.entity(forEntityName: "Localization", in: context)!
        let location = NSManagedObject(entity: newPlace, insertInto: context)
        location.setValue(provider.cityName, forKey: "name")
        location.setValue(provider.longitude, forKey: "longitude")
        location.setValue(provider.latitude, forKey: "latitude")
        location.setValue(provider.weather?.currently.temperature, forKey: "currentTemperature")
        location.setValue(provider.weather?.currently.icon, forKey: "icon")
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        self.tableView.reloadData()
    }
    
    func addLocation(coordinates: Coordinates) {
        self.dataProvider = DataProvider(latitude: coordinates.latitude , longitude: coordinates.longitude , query: "", cityName: coordinates.name)
        dataProvider?.delegate = self
        dataProvider?.getDataFromApi()
    }
}
