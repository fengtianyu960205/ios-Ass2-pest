//
//  CoreDataDatabase.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 6/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import CoreData

class CoreDataDatabaseController: NSObject ,coreDataDatabaseProtocol,NSFetchedResultsControllerDelegate {
    
    var listeners = MulticastDelegate<DatabaseListener>()
       var persistentContainer: NSPersistentContainer
       //var PestsFetchedResultsController: NSFetchedResultsController<PestCD>?
       var UsersFetchedResultsController: NSFetchedResultsController<UserCD>?
    var userID : String?
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        userID = appDelegate.userId
        persistentContainer = NSPersistentContainer(name: "dataModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        super.init()
        if  fetchSpecificUser().count == 0{
            addUser(userID: userID!, age: 30, gender: "man", address: "", nickName: "nkj")
        }
        
    }
    
    
    func cleanup() {
        saveContext()
    }
    
    //save the core data
    func saveContext() {
       
        do {
            try persistentContainer.viewContext.save()
        } catch {
            fatalError("Failed to save to CoreData: \(error)")
        }
       
    }
    
    func addPest(name: String, pestID: String , category : String) -> PestCD {
        let pest = NSEntityDescription.insertNewObject(forEntityName: "PestCD",
        into: persistentContainer.viewContext) as! PestCD
        pest.name = name
        pest.category = category
        
        return pest
    }
    
    func addUser(userID: String, age: Int32, gender: String, address: String, nickName: String) -> UserCD {
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserCD",
        into: persistentContainer.viewContext) as! UserCD
        user.userID = userID
        user.age = 0
        user.gender = gender
        user.address = address
        user.nickName = nickName
        
        return user
    }
    
    func addPestToUser(pestCD: PestCD, userCD: UserCD) {
        userCD.addToPestlist(pestCD)
    }
    
    func removePestFromUser(pestCD: PestCD, userCD: UserCD) {
        userCD.removeFromPestlist(pestCD)
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .users  {
         listener.onUserCDChange(change: .update, user: fetchSpecificUser())
        }
        
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == UsersFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .users  {
                    listener.onUserCDChange(change: .update, user: fetchSpecificUser())
                  
                }
            }
        }
       
    }
    
    func fetchSpecificUser() -> [UserCD] {
        
        if UsersFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<UserCD> = UserCD.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "nickName", ascending: true)
            let predicate = NSPredicate(format: "userID == %@", userID as! CVarArg)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            fetchRequest.predicate = predicate

            UsersFetchedResultsController =
            NSFetchedResultsController<UserCD>(fetchRequest: fetchRequest,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
            
            UsersFetchedResultsController?.delegate = self

            do {
            try UsersFetchedResultsController?.performFetch()
            } catch {
            print("Fetch Request Failed: \(error)")
            }
            }

      
        var users = [UserCD]()
            if UsersFetchedResultsController?.fetchedObjects != nil {
                users = (UsersFetchedResultsController?.fetchedObjects)!
            }

            return users
        
    }
    

}
