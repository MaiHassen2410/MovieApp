//
//  Int+Extention.swift
//  CoreModule
//
//  Created by Mai Hassen on 02/12/2024.
//

import Foundation
extension Int {
 public func formattedWithCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
