//
//  CoreDataHelper.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 11/11/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func updateRecord(city: String, icon: String, temperature: Double) {
        let context = appDelegate.persistentContainer.viewContext
        let lists = fetchRecordsForEntity("Localization", inManagedObjectContext: context, name: city)
        
        if let fetched = lists.first {
            fetched.setValue(icon, forKey: "icon")
            fetched.setValue(temperature, forKey: "currentTemperature")
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        } else {
            print("Cannot find")
            return
        }
    }
    
    func locationAlreadyExists(name: String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let lists = fetchRecordsForEntity("Localization", inManagedObjectContext: context, name: name)
        
        if lists.first != nil {
            return true
        } else {
            return false
        }
    }
    
    private func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext, name: String) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
}
