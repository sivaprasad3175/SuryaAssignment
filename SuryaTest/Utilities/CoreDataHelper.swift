//
//  ParsingHelper.swift
//  SuryaTest
//
//  Created by Siva on 04/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper{
    
    private let persistentContainer: NSPersistentContainer
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
   
    func parse(_ jsonData: Data ) {
        do {
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                print("Failed to retrieve managed object context")
                return
            }
            // Parse JSON data
            let managedObjectContext = persistentContainer.viewContext
            managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            let decoder = JSONDecoder()
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
            _ = try decoder.decode([User].self, from: jsonData)
            appDelegate.saveContext()
        } catch let error {
            print(error)
        }
    }
    
    func getStoredData() -> [User]?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.returnsDistinctResults = true
        do {
            let results = try context.fetch(fetchRequest)
            let userList = results as! [User]
            return userList
        }catch let err as NSError {
            print(err.debugDescription)
        }
        return nil
    }
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

}
