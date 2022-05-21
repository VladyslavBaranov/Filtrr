//
//  Folder+CoreDataClass.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 24.04.2022.
//
//

import Foundation
import CoreData

protocol FolderProtocol {
    var isForFavorites: Bool { get set }
    var isForCreation: Bool { get set }
    var name: String? { get set }
}

public class Folder: NSManagedObject {
    var isForFavorites = false
    var isForCreation = false
    
    var numberOfProjects: Int? = nil
    
    static func createFavoritesFolder() -> Folder {
        let folder = Folder()
        folder.isForFavorites = true
        folder.name = "Favorites"
        return folder
    }
    
    static func createCreationFolder() -> Folder {
        let folder = Folder()
        folder.isForCreation = true
        folder.name = "New Folder"
        return folder
    }
    
    static func dropFolder(_ folder: Folder) {
        let context = AppDelegate.getContext()
        context.delete(folder)
    }
}

class FavoritesFolder: FolderProtocol {
    var isForFavorites: Bool = true
    
    var isForCreation: Bool = false
    
    var name: String? = "Favorties"
}

class CreationFolder: FolderProtocol {
    var isForFavorites: Bool = false
    
    var isForCreation: Bool = true
    
    var name: String? = "New Folder"
}
