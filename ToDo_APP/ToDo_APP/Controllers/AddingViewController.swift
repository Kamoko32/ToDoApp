//
//  AddingViewController.swift
//  ToDo_APP
//
//  Created by Kamil Gucik on 20/05/2020.
//  Copyright © 2020 Kamil Gucik. All rights reserved.
//

import Foundation
import UIKit

protocol NewTaskDelegate: AnyObject {
    func createNewTask (with newTask: NewTask)
}

class AddingViewController: UIViewController {
    
    override func viewDidLoad() {
        createDatePicker()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: nil, action: nil)
    }
    
    
    weak var newTaskDelegate: NewTaskDelegate?
    
    
    @IBOutlet private weak var contentTextField: UITextField!
    @IBOutlet private weak var dataTextField: UITextField!
    @IBOutlet private weak var categorySegment: UISegmentedControl!
    
    
    @IBAction private func add() {
        
        if !(contentTextField.text?.isEmpty ?? false) && !(dataTextField.text?.isEmpty ?? false) {
            
            let content = contentTextField.text!
            let data = dataTextField.text!
            let segmentIndex = categorySegment.selectedSegmentIndex
            let category = categorySegment.titleForSegment(at: segmentIndex)!
            let task = NewTask(content: content, data: data, category: category)
            self.newTaskDelegate?.createNewTask(with: task)
            
            let alert = UIAlertController(title: "Świetnie!", message: "Zadanie zostało dodane.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true)
            
        } else {
            
            let alert = UIAlertController(title: "Błąd !", message: "Nie uzupełniłeś/aś wszystkich pól !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Spróbuj ponownie", style: .default, handler: nil ))
            alert.addAction(UIAlertAction(title: "Anuluj", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            } ))
            self.present(alert, animated: true)
        }
    }
    
   private let datePicker = UIDatePicker()
    
   private func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.timeZone = .current
        datePicker.locale = Locale(identifier: "pl")
        let currentDate = Date()
        datePicker.minimumDate = currentDate as Date
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Zapisz", style: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneButton], animated: true)
        dataTextField.inputAccessoryView = toolbar
        dataTextField.inputView = datePicker
    
    }
    
   @objc func donePressed() {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeZone = .current
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "pl")
    dataTextField.text = formatter.string(from: datePicker.date)
    print(datePicker.date)
    self.view.endEditing(true)
    }
}
