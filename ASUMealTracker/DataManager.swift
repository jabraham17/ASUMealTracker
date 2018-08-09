//
//  DataManager.swift
//  ASU Meal Tracker
//
//  Created by Jacob Abraham on 8/9/18.
//  Copyright © 2018 MJA. All rights reserved.
//

import Foundation
//data management class, singleton
class DataManager {
    
    static let instance = DataManager()
    
    
    //get the file path of the data
    class func getPath() -> String {
        //get the path
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/Week.json"
        return path
    }
    
    //init, read in data from file, if exist
    //if it doesnt, create the file
    init() {
        
        let path = DataManager.getPath()
        
        //if the file at the path does not exist, create it
        if !FileManager.default.fileExists(atPath: path) {
            //attributes is owner, can use default
            //make with no data as file does not exist
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            print("Succesfully created file")
            //since file did not exist, init a new week
            currentWeek = Week(numMeals: 0)
        }
        else {
            //if the file exists, read in the data
            let data = FileManager.default.contents(atPath: path)
            do {
                //decode the data
                let decoder = JSONDecoder()
                currentWeek = try decoder.decode(Week.self, from: data!)
                
                print("Succesfully read file")
            }
            catch {
                print("Failed to parse, making a new Week")
                currentWeek = Week(numMeals: 0)
            }
        }
        
    }
    
    //save all data
    func save() {
        do {
            //encode week
            let encoder = JSONEncoder()
            let data = try encoder.encode(currentWeek!)
            
            //write it to file
            FileManager.default.createFile(atPath: DataManager.getPath(), contents: data, attributes: nil)
            print("Succesfully saved to file")
        }
        catch {
            print("Failed to encode, cannot save")
        }
    }
    
    //the current week that is saved, only saves current week
    var currentWeek: Week?
    
}
