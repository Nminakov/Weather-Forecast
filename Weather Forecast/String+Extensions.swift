//
//  String+Extensions.swift
//  Weather Forecast
//
//  Created by Никита on 03/10/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation


extension String{
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func firstLetter() -> String {
        guard
            let firstChar = self.first else {
                return ""
        }
        return String(firstChar)
    }
}
