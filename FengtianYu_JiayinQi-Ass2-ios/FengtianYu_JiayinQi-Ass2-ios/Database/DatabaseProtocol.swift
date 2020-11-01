//
//  DatabaseProtocol.swift
//  turorial3
//
//  Created by 俞冯天 on 29/8/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

enum DatabaseChange {
    case add
    case remove
    case update
    case delete
}
enum ListenerType {
    case pests
    case all
}
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onPestChange(change: DatabaseChange, pests: [Pest])
    //func onHeroListChange(change: DatabaseChange, heroes: [SuperHero])
}
protocol DatabaseProtocol: AnyObject {
    //var defaultTeam: Team {get}

    func cleanup()
    func addPest(name: String, category: String) -> Pest
    //func addTeam(teamName: String) -> Team
    //func addHeroToTeam(hero: SuperHero, team: Team) -> Bool
    func deletePest(pest: Pest)
    //func deleteTeam(team: Team)
    //func removeHeroFromTeam(hero: SuperHero, team: Team)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
