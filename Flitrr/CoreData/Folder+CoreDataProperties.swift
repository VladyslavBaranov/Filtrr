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
