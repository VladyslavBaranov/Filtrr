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
    
    func toggleIsFavorites() {
        let context = AppDelegate.getContext()
        isFavorite.toggle()
        do {
            try context.save()
        } catch {
        }
    }
    
    static func createProjectAndSave(pngData: Data) {
        let context = AppDelegate.getContext()
        let project = Project(context: context)
        project.id = UUID()
        project.isFavorite = false
        project.data = pngData
        do {
            try context.save()
        } catch {
        }
    }
    
    static func getAvailableProjects() -> [Project] {
        let context = AppDelegate.getContext()
        do {
            let req = fetchRequest()
            req.propertiesToFetch = ["id", "isFavorite"]
            let folders = try context.fetch(fetchRequest())
            return folders
        } catch {
            return []
        }
    }
    
    static func deleteProject(_ project: Project) -> Bool {
        let context = AppDelegate.getContext()
        context.delete(project)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
}
