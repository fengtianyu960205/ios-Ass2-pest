//
//  FirebaseController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 1/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseController: NSObject,DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var pestsRef: CollectionReference?
    var pestList: [Pest]
   
    override init(){
        
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        pestList = [Pest]()
        super.init()
        
        self.setUpPestListener()
    }
    
    func setUpPestListener() {
        pestsRef = database.collection("pests")
        pestsRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parsePestsSnapshot(snapshot: querySnapshot)

        }
    }
    
    func parsePestsSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let pestID = change.document.documentID
            print(pestID)

            var parsedPest: Pest?

            do {
                parsedPest = try change.document.data(as: Pest.self)
                } catch {
                print("Unable to decode pest. Is the pest malformed?")
                return
            }

            guard let pest = parsedPest else {
                print("Document doesn't exist")
                return;
            }

            pest.id = pestID
            if change.type == .added {
                pestList.append(pest)
                }
            else if change.type == .modified {
                let index = getPestIndexByID(pestID)!
                pestList[index] = pest
            }
            else if change.type == .removed {
                if let index = getPestIndexByID(pestID) {
                    pestList.remove(at: index)
                }
                }
            }

        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.heroes ||
                listener.listenerType == ListenerType.all {
                listener.onPestChange(change: .update, pests: pestList)
            }
        }
    }
    
    
    func getPestIndexByID(_ id: String) -> Int? {
            if let pest = getPestByID(id) {
                return pestList.firstIndex(of: pest)
        }

        return nil
    }
    
    func getPestByID(_ id: String) -> Pest? {
        for pest in pestList {
            if pest.id == id {
                return pest
            }
        }

        return nil
    }
    
    
    func cleanup() {
        <#code#>
    }
    
    func addPest(name: String, category: String) -> Pest {
        <#code#>
    }
    
    func deletePest(pest: Pest) {
        <#code#>
    }
    
    func addListener(listener: DatabaseListener) {
        <#code#>
    }
    
    func removeListener(listener: DatabaseListener) {
        <#code#>
    }
    

}
