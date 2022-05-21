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

    @NSManaged public var created: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var folder_id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var url: URL?

}

extension Project : Identifiable {
    
    func log() {
        print("____")
        print(url ?? "")
        print(id ?? "")
        print(isFavorite)
    }
    
    func toggleIsFavorites() {
        let context = AppDelegate.getContext()
        isFavorite.toggle()
        do {
            try context.save()
        } catch {
        }
    }
    
    func getPNGData() -> Data? {
        guard let url = url?.lastPathComponent else { return nil }
        print("#", url)
        let png = ProjectsFileManager.shared.getImageDataWith(fileName: url)
        switch png {
        case .success(let data):
            return data
        default:
            return nil
        }
    }
    
    static func createProjectAndSave(pngData: Data) {
        let context = AppDelegate.getContext()
        let project = Project(context: context)
        let id = UUID()
        project.id = id
        project.isFavorite = false
        project.created = Date()
        if let url = ProjectsFileManager.shared.createPNGImage(pngData, id: id) {
            project.url = url
            do {
                try context.save()
            } catch {
            }
        }
    }
    
    static func getLastFavoriteProject() -> Project? {
        getAllAvailableProjects().filter { $0.isFavorite }.first
    }
    
    static func getAllAvailableProjects() -> [Project] {
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
    
    static func getProjects(folder_id: UUID) -> [Project] {
        print("#REQUESTING FOLDER ID: \(folder_id)")
        let context = AppDelegate.getContext()
        do {
            let req = fetchRequest()
            // req.predicate = NSPredicate(format: "folder_id == %@", folder_id.uuidString)
            req.propertiesToFetch = ["id", "isFavorite", "folder_id"]
            let folders = try context.fetch(fetchRequest())
            return folders.filter { $0.folder_id == folder_id }
        } catch {
            return []
        }
    }
    
    static func getProjectsNilFolder() -> [Project] {
        let context = AppDelegate.getContext()
        do {
            let req = fetchRequest()
            req.predicate = NSPredicate(format: "folder_id == nil")
            req.propertiesToFetch = ["id", "isFavorite"]
            let folders = try context.fetch(fetchRequest())
            return folders.filter { $0.folder_id == nil }
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
    
    static func deleteAll() {
        let pr = Project.getAllAvailableProjects()
        for project in pr {
            _ = Project.deleteProject(project)
        }
    }
}
