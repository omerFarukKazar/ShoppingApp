//
//  CoreDataManager.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 28.03.2023.
//

import UIKit
import CoreData

protocol CoreDataManager { }

extension CoreDataManager {
    var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }

    var context: NSManagedObjectContext? {
        guard let appDelegate = appDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }

    func saveToCoreData<T>(data: T, entityName: String, attributeName: String) throws {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(data, forKey: attributeName)
        do {
            try context.save()
        } catch {
            throw(error)
        }
    }

    func getDataFromCoreData<T>(entityName: String,
                                attributeName: String,
                                completion: ((T?, Error?) -> Void)) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            guard let fetchResults = try context?.fetch(fetchRequest),
                  let fetchResultsObjects = fetchResults as? [NSManagedObject] else { return }

            for userCoreData in fetchResultsObjects {
                if let data = userCoreData.value(forKey: attributeName) as? T {
                    completion(data, nil)
                }
            }
        } catch {
            completion(nil, error)
        }
    }
    
}
