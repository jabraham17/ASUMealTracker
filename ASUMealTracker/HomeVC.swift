//
//  ViewController.swift
//  ASU Meal Tracker
//
//  Created by Jacob Abraham on 8/8/18.
//  Copyright © 2018 MJA. All rights reserved.
//

import UIKit

//TODO:
//make notifications about hiw many meaks left
//make a catalog of old meals
//share old meals across devices


//controls the home screen
class HomeVC: UITableViewController, MealCellListener {
    
    //refrencde to meal count button
    @IBOutlet weak var mealCountButton: UIBarButtonItem!
    
    //button to change the number of avaible meals in a week
    @IBAction func mealCountChange(_ sender: UIBarButtonItem) {
        
        //create an alert with text field to change meal count
        let alert = UIAlertController(title: "Change Meal Count", message: "Change the number of meals present in a week, this is based on your meal plan", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = "\(self.getCurrentWeek().numberOfMeals())"
            textField.keyboardType = .numberPad
        })
        //on ok, change meal plan
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (a) in
            //check for valid entry
            guard let contentOfField = alert.textFields?.first!.text else { return }
            guard let newNumber = Int(contentOfField) else { return }
            //change it
            self.getCurrentWeek().changeMealPlan(newNumMeals: newNumber)
            //change to what text is
            sender.title = "\(self.getCurrentWeek().numberOfMeals())"
            DataManager.instance.save()
            self.tableView.reloadData()
        }))
        
        //cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        //show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //check to make sure the current week loaded in is the actual current week
    func checkWeek() {
        //if the end date is in the past, make a new week with the old meal plan
        if getCurrentWeek().endDate.timeIntervalSinceNow.sign == .minus {
            let numMeals = getCurrentWeek().numberOfMeals()
            let newWeek = Week(numMeals: numMeals)
            DataManager.instance.currentWeek = newWeek
            print("New Week, reset")
            DataManager.instance.save()
        }
        
        //if the start date is in the future, make a new week with the old meal plan
        if getCurrentWeek().startDate.timeIntervalSinceNow.sign == .plus {
            let numMeals = getCurrentWeek().numberOfMeals()
            let newWeek = Week(numMeals: numMeals)
            DataManager.instance.currentWeek = newWeek
            print("New Week, reset")
            DataManager.instance.save()
        }
    }
    
    //when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkWeek()
        
        print(timeFormatter.string(from: getCurrentWeek().startDate))
        print(timeFormatter.string(from: getCurrentWeek().endDate))
        
        //set the title
        self.navigationItem.title = "\(shortDateFormatter.string(from: getCurrentWeek().startDate)) - \(shortDateFormatter.string(from: getCurrentWeek().endDate))"
        
        mealCountButton.title = "\(getCurrentWeek().numberOfMeals())"
        
    }
    
    func getCurrentWeek() -> Week {
        return DataManager.instance.currentWeek!
    }

    //number of rows is current week
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCurrentWeek().numberOfMeals()
    }
    
    //formatter for the dates
    var dateFormatter: DateFormatter {
        let format = DateFormatter()
        format.locale = Locale.current
        format.setLocalizedDateFormatFromTemplate("EEE, MMM dd, yyyy")
        return format
    }
    //short formatter for the dates
    var shortDateFormatter: DateFormatter {
        let format = DateFormatter()
        format.locale = Locale.current
        format.dateStyle = .short
        return format
    }
    //formatter for the times
    var timeFormatter: DateFormatter {
        let format = DateFormatter()
        format.locale = Locale.current
        format.timeStyle = .short
        return format
    }
    
    //make the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell") as! MealCell
        
        //set the state of the switch
        cell.toggle.isOn = (getCurrentWeek().getMeal(index: indexPath.row)?.eaten)!
        
        //add the date eaten
        cell.index = indexPath.row
        updateMealDate(cell: cell)
        
        //add the listener
        cell.listener = self
        
        return cell
    }

    
    //update meal in response to switch change
    func mealStateChangeListener(index: Int?, state: Bool) {
        guard let i = index else { return }
        getCurrentWeek().changeMealStatus(index: i, eaten: state)
        
        DataManager.instance.save()
        
        //update the cell
        let cell = tableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as! MealCell
        updateMealDate(cell: cell)
    }
    //change the date for a cell
    func updateMealDate(cell: MealCell) {
        let dateEaten = getCurrentWeek().getMeal(index: cell.index!)?.getDateEaten()
        if dateEaten != nil {
            cell.mealEatenDate.text = "\(dateFormatter.string(from: dateEaten!)) at \(timeFormatter.string(from: dateEaten!))"
        }
        else {
            cell.mealEatenDate.text = "Not Used"
        }
    }
}

