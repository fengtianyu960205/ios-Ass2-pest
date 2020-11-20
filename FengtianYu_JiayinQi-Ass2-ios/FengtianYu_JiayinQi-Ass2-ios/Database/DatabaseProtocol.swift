//
//  DatabaseProtocol.swift
//  turorial3
//
//  Created by 俞冯天 on 29/8/20.
//  Copyright © 2020 Monash University. All rights reserved.
//
import UIKit
import CoreData


enum DatabaseChange {
    case add
    case remove
    case update
    case delete
}
enum ListenerType {
    case pests
    case users
    case all
}
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onPestChange(change: DatabaseChange, pests: [Pest])
    func onUserCDChange(change: DatabaseChange, user: [UserCD])
    //func onHeroListChange(change: DatabaseChange, heroes: [SuperHero])
}
protocol DatabaseProtocol: AnyObject {
    //var defaultTeam: Team {get}

    func cleanup()
    func addPest(name: String, category: String) -> Pest
    //func addTeam(teamName: String) -> Team
    //func addHeroToTeam(hero: SuperHero, team: Team) -> Bool
    func deletePest(pest: Pest)
    func addPestComment(id: String, comment: String)
    func addPestLocation(id: String, location:String) 
    //func getSpecificPest(id: String) -> Pest
    func getPestByID(_ id: String) -> Pest?
    //func deleteTeam(team: Team)
    //func removeHeroFromTeam(hero: SuperHero, team: Team)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func getPests() ->  [Pest]
    func getPestidByName(pestName : String) -> String 
}


protocol coreDataDatabaseProtocol: AnyObject {
    

    func cleanup()
    
    func fetchSpecificUser() -> [UserCD]
    func addPest(name: String, pestID: String, category : String ,pestImage : Data) -> PestCD
    
    func addUser(userID: String,age:Int32,gender:String,address:String ,nickName: String, userImage : Data) -> UserCD
    
    func addPestToUser(pestCD: PestCD, userCD: UserCD)
    func removePestFromUser(pestCD: PestCD, userCD: UserCD)

    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
}
