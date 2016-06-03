//
//  Person+CoreDataProperties.swift
//  Quizomania
//
//  Created by Mariusz Czeszejko-Sochacki on 02/06/16.
//  Copyright © 2016 Mariusz Czeszejko-Sochacki. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var best_score: NSNumber?
    @NSManaged var username: String?

}
