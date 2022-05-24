//
//  Folder+CoreDataProperties.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 24.04.2022.
//
//

import Foundation
import CoreData


extension Folder: FolderProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var created: Date?
    @NSManaged public var name: String?
    
    func getProjects() -> [Project] {
        guard let id = id else {
            return []
        }
        return Project.getProjects(folder_id: id)
    }
    
    func getLastProjectURL(forFavorites: Bool) -> URL? {
        let projects = Project.getAllAvailableProjects()
        if forFavorites {
            return projects.last?.url
        } else {
            let folderProjects = projects.filter { $0.folder_id == id }
            return folderProjects.last?.url
        }
    }
    
    func loadProjectsCount(forceReload: Bool = false) -> Int {
        if numberOfProjects == nil || forceReload {
            let projects = Project.getAllAvailableProjects()
            let folderProjects = projects.filter { $0.folder_id == id }
            self.numberOfProjects = folderProjects.count
            return folderProjects.count
        }
        return numberOfProjects ?? 0
    }
    func insert(projects: [Project]) -> Bool {
        guard !projects.isEmpty else { return false }
        let ctx = AppDelegate.getContext()
        for project in projects {
            project.folder_id = id
        }
        do {
            try ctx.save()
            return true
        } catch {
            return false
        }
    }
    
    func rename(_ newName: String) -> Bool {
        guard newName != name else { return false }
        let context = AppDelegate.getContext()
        name = newName
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    static func createFolderAndSave(name: String) -> Folder {
        let context = AppDelegate.getContext()
        let folder = Folder(context: context)
        folder.id = UUID()
        folder.created = Date()
        folder.name = name
        
        do {
            try context.save()
            return folder
        } catch {
            fatalError()
        }
    }
    
    static func getAvailableFolders() -> [Folder] {
        let context = AppDelegate.getContext()
        do {
            let folders = try context.fetch(fetchRequest())
            return folders
        } catch {
            return []
        }
    }
}

extension Folder : Identifiable {

}
