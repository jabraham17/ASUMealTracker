//
//  Week.swift
//  ASU Meal Tracker
//
//  Created by Jacob Abraham on 8/8/18.
//  Copyright © 2018 MJA. All rights reserved.
//

import Foundation

//data storage
//represents a week
//has a certain number of meals
//has a start and end date
//has a list of meals
class Week: Codable {
    
    let startDate: Date
    let endDate: Date
    private var numMeals: Int
    private var meals: [Meal]
    
    init(numMeals: Int) {
        //todays date
        let today = Date()
        
        //use to calc dates
        let calendar = Calendar(identifier: .gregorian)
        
        //current weekday
        let current = calendar.component(.weekday, from: today)
        
        //if today is wednesday, set it to start date
        if current == 4 {
            startDate = today
        }
        else {
            //find the last wednesday, which is start day
            var dateComp = DateComponents()
            dateComp.weekday = 4
            startDate = calendar.nextDate(after: today, matching: dateComp, matchingPolicy: .nextTime, direction: .backward)!
        }
        
        
        //if today is tuesday, set it to end date
        if current == 3 {
            endDate = today
        }
        else {
            //find the next tuesdaty, which is end day
            var dateComp = DateComponents()
            dateComp.weekday = 3
            endDate = calendar.nextDate(after: today, matching: dateComp, matchingPolicy: .nextTime, direction: .forward)!
        }
        
        //init meals
        self.numMeals = numMeals
        meals = []
        for _ in 0..<self.numMeals {
            meals.append(Meal())
        }
    }
    
    init(startDate: Date, endDate: Date, numMeals: Int, meals: [Meal]) {
        self.startDate = startDate
        self.endDate = endDate
        self.numMeals = numMeals
        self.meals = meals
    }
    
    //change the number of meals in the week
    func changeMealPlan(newNumMeals: Int) {
        //if no change, skip
        if newNumMeals == numMeals {
            return
        }
        //if more meals to be added, add them
        if newNumMeals > numMeals {
            let diff = newNumMeals - numMeals
            for _ in 0..<diff {
                meals.append(Meal())
            }
        }
        //if less meals, remove meals
        else if newNumMeals < numMeals {
            let diff = numMeals - newNumMeals
            for _ in 0..<diff {
                _ = meals.popLast()
            }
        }
        //set new meal number
        numMeals = newNumMeals
    }
    
    //change the status of specific meal
    func changeMealStatus(index: Int, eaten: Bool) {
        //if out of bounds meal index, do nothing
        if index >= numMeals {
            return
        }
        meals[index].eaten = eaten
    }
    //get a meal at index
    func getMeal(index: Int) -> Meal? {
        //if out of bounds meal index, return nothing
        if index >= numMeals {
            return nil
        }
        return meals[index]
    }
    
    //get the number of meals
    func numberOfMeals() -> Int {
        return numMeals
    }
}
