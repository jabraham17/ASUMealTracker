//
//  Meal.swift
//  ASU Meal Tracker
//
//  Created by Jacob Abraham on 8/8/18.
//  Copyright © 2018 MJA. All rights reserved.
//

import Foundation

//represents a single meal, has a date eaten
class Meal: Codable {
    //whether meal has been eaten
    var eaten: Bool {
        didSet {
            //if it has now been eaten, set the date
            if eaten {
                dateEaten = Date()
            }
            //no longer eaten, remove the date
            else {
                dateEaten = nil
            }
        }
    }
    private var dateEaten: Date?
    
    func getDateEaten() -> Date? {
        return dateEaten
    }
    
    init() {
        eaten = false
        dateEaten = nil
    }
    
    init(eaten: Bool, dateEaten: Date?) {
        self.eaten = eaten
        self.dateEaten = dateEaten
    }
}
