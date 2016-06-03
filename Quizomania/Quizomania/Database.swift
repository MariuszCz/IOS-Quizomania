//
//  Database.swift
//  Quizomania
//
//  Created by Mariusz Czeszejko-Sochacki on 03/06/16.
//  Copyright © 2016 Mariusz Czeszejko-Sochacki. All rights reserved.
//

import Foundation
import CoreData
class Database {
    var people = [NSManagedObject]()

    func fetchScores(managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {

        let fetchRequest = NSFetchRequest(entityName: "Person")

        do {
            let results =
                try managedObjectContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return people
    }
    
    func saveUserName(managedObjectContext: NSManagedObjectContext, username:String!, scores:Int!) {
        let entityDescription =
            NSEntityDescription.entityForName("Person",
                                              inManagedObjectContext: managedObjectContext)
        
        let person = Person(entity: entityDescription!,
                            insertIntoManagedObjectContext: managedObjectContext)
        
        if  username != nil && scores != nil {
            person.setValue(username, forKey: "username")
            person.setValue(scores, forKey: "best_score")
            
            do {
                try person.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
    }
}