//
//  Models.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 1/16/18.
//  Copyright © 2018 Michael Fulton Jr. All rights reserved.
//

import Foundation
import UIKit

struct User {
//    init(){
//
//    }
    var userID: String
    var userName: String
    var email: String
    var image: UIImage?
}

struct Event {
    //    init(){
    //
    //    }
    var title: String
    var description: String
    var speaker: String
    var time: Date
    var location: String
}

struct TriviaItem {
    //    init(){
    //
    //    }
    var question: String
    var answer: String
    var points: Int
}

struct Factoid {
    var person: String
    var bio: String
    var image: String
}
