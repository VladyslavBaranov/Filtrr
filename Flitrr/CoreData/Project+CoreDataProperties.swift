//
//  Project+CoreDataProperties.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 24.04.2022.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var folder_id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var data: Data?

}

extension Project : Identifiable {

}
