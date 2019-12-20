//
//  NewExpanseController.swift
//  My Cash
//
//  Created by Roman Rakhlin on 08.10.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit

protocol TransactionHandler {
    func newTransaction(amout: Float, category: String, note: String, date: Date, spend: Bool, newTranscation: Bool)
}

class NewTransactionController: UIViewController, Category, UITextFieldDelegate {
   
    @IBOutlet var amountTextField: UITextField! = nil
    @IBOutlet var categoryTextField: UITextField! = nil
    @IBOutlet var noteTextField: UITextField! = nil
    @IBOutlet var dateTextField: UITextField! = nil
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var justView: UIView!
    
    var moneySpend: Bool = true
    var newTransaction: Bool = true
    var delegate: TransactionHandler?
    
    var amount = Float()
    var category = String()
    var note = String()
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if newTransaction == false {
            datePicker.date = date
            updateDate()
            
            if moneySpend == true {
                segmentControl.selectedSegmentIndex = 0
            } else {
                segmentControl.selectedSegmentIndex = 1
            }
            
            DispatchQueue.main.async {
                self.amountTextField.text = "\(self.amount)"
                self.categoryTextField.text = self.category
                self.noteTextField.text = self.note
            }
        }
        
        datePicker.isHidden = true
        updateDate()
        
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        dateTextField.addGestureRecognizer(tapGesture)
        
        amountTextField.delegate = self
        categoryTextField.delegate = self
        noteTextField.delegate = self
        
        amountTextField.addDoneButtonToKeyboard(myAction:  #selector(self.amountTextField.resignFirstResponder))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        amountTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()
        return true;
    }
    
    @IBAction func segmentedSwitcher(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            moneySpend = true
//            self.justView.backgroundColor = UIColor.red
        } else {
            moneySpend = false
//            self.justView.backgroundColor = UIColor.green
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let floatNumber = (amountTextField.text! as NSString).floatValue
        if floatNumber == 0 {
            let alert = UIAlertController(title: "Error", message: "enter amount", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            delegate?.newTransaction(amout: floatNumber, category: categoryTextField.text!, note: noteTextField.text!, date: datePicker.date, spend: moneySpend, newTranscation: newTransaction)
            navigationController?.popToRootViewController(animated: true)
        }

    }
    
    @objc func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        dateTextField.text = selectedDate
    }
    
    @objc func showDatePicker() {
        datePicker.isHidden = false
        //dateTextField.isEnabled = false
        
        amountTextField.endEditing(true)
        categoryTextField.endEditing(true)
        noteTextField.endEditing(true)
        dateTextField.endEditing(true)
    }
    
    func selectedCategory(category: String) {
        categoryTextField.text = category
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategories" {
            let destinationVC = segue.destination as! CategoriesController
            destinationVC.spend = moneySpend
            destinationVC.delegate = self
        }
    }
    
}

extension UITextField{

 func addDoneButtonToKeyboard(myAction:Selector?){
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    doneToolbar.barStyle = UIBarStyle.default

    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: myAction)

    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)

    doneToolbar.items = items
    doneToolbar.sizeToFit()

    self.inputAccessoryView = doneToolbar
 }
}
