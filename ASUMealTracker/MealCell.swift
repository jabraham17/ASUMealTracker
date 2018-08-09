//
//  MealCell.swift
//  ASU Meal Tracker
//
//  Created by Jacob Abraham on 8/8/18.
//  Copyright © 2018 MJA. All rights reserved.
//

import UIKit

protocol MealCellListener: class {
    func mealStateChangeListener(index: Int?, state: Bool)
}

//custom action for meal cell
class MealCell: UITableViewCell {
    
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var mealEatenDate: UILabel!
    //when state is switch, change state of meal
    @IBAction func mealStateSwitch(_ sender: UISwitch) {
        listener?.mealStateChangeListener(index: index, state: sender.isOn)
    }
    //listener to tell vc that state changed
    weak var listener: MealCellListener?
    //index of cell
    var index: Int?
}
