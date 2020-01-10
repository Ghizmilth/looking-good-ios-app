//
//  Users.swift
//  LookingGood
//
//  Created by Hidaner Ferrer on 1/8/20.
//  Copyright © 2020 Hidaner Ferrer. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var firstname: String
    var lastname: String
    var leanBodyGoal: Double
    var age: Int
    var weight: [Double] = []
    var leanBodyWeight: [Double] = []
    var bodyFatPerc: [Double] = []
    
}
