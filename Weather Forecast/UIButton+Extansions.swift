//
//  UIButton+Extansions.swift
//  Weather Forecast
//
//  Created by Никита on 19/09/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit

extension UIButton{
    
    func animateTap(callback: @escaping() -> Void){
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            }) { (_) in
                callback()
            }
        }
    }
    
    
}
