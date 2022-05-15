//
//  Project+CoreDataClass.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 24.04.2022.
//
//

import Foundation
import CoreData

/*
 static func createProjectAndSave(pngData: Data) {
     let context = AppDelegate.getContext()
     let project = Project(context: context)
     project.id = UUID()
     project.created = Date()
     project.isFavorite = false
     do {
         guard let url = ProjectsFileManager.shared.createPNGImage(pngData, name: "\(project.id.uuidString)") else { return }
         project.url = url
         try context.save()
     } catch {
     }
 }
 
 static func getAvailableProjects() -> [Project] {
     let context = AppDelegate.getContext()
     do {
         let folders = try context.fetch(fetchRequest())
         return folders
     } catch {
         return []
     }
 }
 
 static func deleteProject(_ project: Project) -> Bool {
     let url = project.url
     let context = AppDelegate.getContext()
     context.delete(project)
     do {
         ProjectsFileManager.shared.dropPNG(url)
         try context.save()
         return true
     } catch {
         return false
     }
 }
 */


public class Project: NSManagedObject {
    var isSelected = false
}

