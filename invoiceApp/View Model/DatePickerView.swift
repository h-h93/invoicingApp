//
//  DatePickerView.swift
//  invoiceApp
//
//  Created by hanif hussain on 07/01/2024.
//

import UIKit

class DatePickerView: UIView {

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = .now
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let toolbar = UIToolbar();
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(datePicker)
        
        
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
          let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func donedatePicker(sender: UIBarButtonItem){

       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"

        self.endEditing(true)
     }

     @objc func cancelDatePicker(){
         self.endEditing(true)
      }
    
}
