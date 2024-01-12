//
//  Extensions.swift
//  invoiceApp
//
//  Created by hanif hussain on 06/01/2024.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow(scale: Bool = true, shadowRadius: CGFloat = 10) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UITableView {
    /// Reloads a table view without losing track of what was selected.
    func reloadDataSavingSelections() {
        let selectedRows = indexPathsForSelectedRows
        
        reloadData()
        
        if let selectedRow = selectedRows {
            for indexPath in selectedRow {
                selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    func setUnderLine() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width - 10, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    func makeDatePredicate(startDate: Date, endDate: Date) -> NSPredicate {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        let formattedStartDate = formatter.date(from: formatter.string(from: startDate))
        let formattedEndDate = formatter.date(from: formatter.string(from: endDate))
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        var startComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: formattedStartDate!)
        var endComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: formattedEndDate!)
        
        startComponents.hour = 00
        startComponents.minute = 00
        startComponents.second = 00
        let startDate = calendar.date(from: startComponents)
        
        endComponents.hour = 23
        endComponents.minute = 59
        endComponents.second = 59
        let endDate = calendar.date(from: endComponents)

        
        // change predicate date to day, timestamp or anything else relating to the attribute in your core data entity
        return NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startDate!, endDate!])
    }
    
    func makeTimestampPredicate(startDate: Date, endDate: Date) -> NSPredicate {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        var startComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate)
        var endComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endDate)
        startComponents.hour = 00
        startComponents.minute = 00
        startComponents.second = 00
        let startDate = calendar.date(from: startComponents)
        endComponents.hour = 23
        endComponents.minute = 59
        endComponents.second = 59
        let endDate = calendar.date(from: endComponents)
        
        // 2024-01-07 16:30:03 +0000
        // 2024-01-07 16:30:03 +0000
        
        // change predicate date to day, timestamp or anything else relating to the attribute in your core data entity
        return NSPredicate(format: "timestamp >= %@ AND timestamp <= %@", argumentArray: [startDate!, endDate!])
    }

}
