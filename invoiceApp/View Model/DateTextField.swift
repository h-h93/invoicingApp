//
//  customTextField.swift
//  invoiceApp
//
//  Created by hanif hussain on 07/01/2024.
//

import Foundation
import UIKit

/// Date text field delegate protocol

@objc protocol CustomTextFieldDelegate {
    @objc optional
    func dateTextField(_ dateTextField: CustomTextField, didChangeDate: Date?)

    @objc optional
    func didTapDone(dateTextField: CustomTextField)
}

/// Date text field
///
/// Used for entry of dates in UITextField, replacing keyboard with date picker.

class CustomTextField: UITextField {
    
    weak var textFieldDelegate: CustomTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
