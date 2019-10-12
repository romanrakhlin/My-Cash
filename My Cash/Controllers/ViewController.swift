//
//  ViewController.swift
//  My Cash
//
//  Created by Roman Rakhlin on 08.10.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TransactionHandler {
    
    @IBOutlet var justView: UIView!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultController: NSFetchedResultsController<Transaction>!
    
    let defaults = UserDefaults.standard
    var balance: Float = 0
    var index: IndexPath!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        balance = defaults.float(forKey: "Balance")
        balanceLabel.text = NSString(format: "%.2f", balance) as String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultController.sections else {
            fatalError("No sections in fetchedResultController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: Cell, at indexPath: IndexPath) {
        guard let transaction = self.fetchedResultController?.object(at: indexPath) else {
            fatalError("Can't configure cell")
        }
        
        cell.categoryLabel.text = transaction.category
        cell.noteLabel.text = transaction.note ?? ""
        
        if transaction.expanse == true {
            cell.amountLabel.textColor = UIColor.red
            cell.amountLabel.text = "-\(transaction.amount)"
        } else {
            cell.amountLabel.textColor = UIColor.green
            cell.amountLabel.text = "+\(transaction.amount)"
        }
        
        cell.layer.cornerRadius = 20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultController?.sections?[section] else {
            return nil
        }

        return sectionInfo.name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let transcation = self.fetchedResultController?.object(at: indexPath) else { fatalError("Error") }
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.balanceCalculation(transaction: transcation)
            self.defaults.set(self.balance, forKey: "Balance")
            self.balanceLabel.text = NSString(format: "%.2f", self.balance) as String
            self.context.delete(transcation)
            self.saveData()
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.index = self.fetchedResultController.indexPath(forObject: transcation)
            self.balanceCalculation(transaction: transcation)
            self.performSegue(withIdentifier: "newTransaction", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    func balanceCalculation(transaction: Transaction) {
        if transaction.expanse == true {
            self.balance += transaction.amount
        } else {
            self.balance -= transaction.amount
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTransaction" {
            let destinationVC = segue.destination as! NewTransactionController
            destinationVC.delegate = self
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.newTransaction = false
                let transcation = fetchedResultController.object(at: indexPath)
                destinationVC.amount = transcation.amount
                destinationVC.category = transcation.category ?? ""
                destinationVC.note = transcation.note ?? ""
                destinationVC.date = transcation.date!
                destinationVC.moneySpend = transcation.expanse
            }
        }
    }
    
    func newTransaction(amout: Float, category: String, note: String, date: Date, spend: Bool, newTranscation: Bool) {
        if newTranscation == true {
            let transaction = Transaction(context: context)
            
            transaction.category = category
            transaction.note = note
            transaction.date = date
            transaction.amount = amout
            transaction.expanse = spend
            
            balanceOperation(spend: spend, amount: amout)
            
        } else {
            guard let transaction = fetchedResultController?.object(at: index) else { fatalError("No object with this IndexPath") }
            transaction.amount = amout
            transaction.category = category
            transaction.note = note
            transaction.expanse = spend
            transaction.date = date
            
            balanceOperation(spend: spend, amount: amout)
            
            tableView.reloadData()
        }
        
        saveData()
        
        balanceLabel.text = NSString(format: "%.2f", balance) as String
    }
    
    func balanceOperation(spend: Bool, amount: Float) {
        if spend == true {
            balance -= amount
            defaults.set(balance, forKey: "Balance")
            
        } else {
            balance += amount
            defaults.set(balance, forKey: "Balance")
        }
    }
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Saving error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(Transaction.isDate), cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Load data error: \(error)")
        }
        
        tableView.reloadData()
    }

}

extension Transaction {
    
    @objc var isDate: String {
        get {
            let dateFromatter = DateFormatter()
            dateFromatter.dateFormat = "MMMM dd"
            
            return dateFromatter.string(from: date!)
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                print("Added:\(indexPath)")
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                print("Delete:\(indexPath)")
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                print("Move:\(newIndexPath)")
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        @unknown default:
            break
        }
        
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        default:
            break
        }
    }
}
