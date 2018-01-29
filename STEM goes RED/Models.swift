//
//  Models.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 1/16/18.
//  Copyright © 2018 Michael Fulton Jr. All rights reserved.
//

import Foundation
import UIKit



struct Player {
    var userInfo: LocalUser!
    var score: Int!
}

struct LocalUser {
    var userID: String!
    var userName: String!
    var email: String!
}

struct Event {
    //    init(){
    //
    //    }
    var title: String!
    var description: String!
    var speaker: String!
    var time: String!
    var location: String!
    var date: Date!
    
    static func convertToDate(time: String) -> Date {
        var components = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        var timeComp1 = time.split(separator: ":")
        var timeComp2 = timeComp1[1].split(separator:" ")
        components.hour = Int(timeComp1[0])
        components.minute = Int(timeComp2[0])
        return calendar.date(from: components)!
        
    }
    
    func convertDateToString(date: Date) {
        
    }
}

struct TriviaItem {
    //    init(){
    //
    //    }
    var question: String!
    var answer: String!
    var points: Int!
    var choices: [String]!
    var answered: Bool!
    var category: String!
}

struct Factoid {
    var person: String
    var bio: String
    var image: String
}
