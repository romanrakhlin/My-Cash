//
//  CategoriesController.swift
//  My Cash
//
//  Created by Roman Rakhlin on 08.10.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit

protocol Category {
    func selectedCategory(category: String)
}

class CategoriesController: UITableViewController {
    
    var spend = Bool()
    var delegate: Category?
    
    let expenseCategories: [String] = ["Shopping", "Food", "Payments", "Car", "Other"]
    let incomeCategories: [String] = ["Gift", "Salary", "Sale", "Business", "Dividends", "Other"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return spend ? expenseCategories.count : incomeCategories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        if spend == true {
            cell.categoryLabel.text = expenseCategories[indexPath.row]
        } else {
            cell.categoryLabel.text = incomeCategories[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! CategoryCell
        
        delegate?.selectedCategory(category: selectedCell.categoryLabel.text!)
        navigationController?.popViewController(animated: true)
    }
}
