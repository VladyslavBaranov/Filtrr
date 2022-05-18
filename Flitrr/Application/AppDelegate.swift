//
//  AppDelegate.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.04.2022.
//

import UIKit
import CoreData
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static func getContext() -> NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SKPaymentQueue.default().add(StoreObserver.shared)
        
        // IMG_E73B3163-93F7-45A9-B610-5145EDC61652.png
        // if let png = UIImage(named: "BlueStar5")?.pngData() {
        //     let res = ProjectsFileManager.shared.createPNGImage(png, id: UUID())
        //     print(res)
        // }
        
        //IMG_E73B3163-93F7-45A9-B610-5145EDC61652.png
        // let png = ProjectsFileManager.shared.getImageDataWith(fileName: "IMG_40735B28-B72F-4BD2-8E9E-54E1FEC07A0C.png")
        // switch png {
        // case .success(let data):
        //     print("bytes", data.count)
        // default:
        //     print("ERROR")
        // }
        
        //Project.deleteAll()
        //if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        //    if let cs = try? FileManager.default.contentsOfDirectory(atPath: dir.path) {
        //        print(cs)
        //        //for c in cs {
        //        //    try? FileManager.default.removeItem(at: dir.appendingPathComponent(c))
        //        //}
        //
        //    }
        //}
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		[.portrait, .portraitUpsideDown]
	}
    
    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(StoreObserver.shared)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Flitrr")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

