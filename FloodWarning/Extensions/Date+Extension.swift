//
//  Date+Extension.swift
//  FloodWarning
//
//  Created by Doyinsola Osanyintolu on 10/18/20.
//

import Foundation

extension Date {
    
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
