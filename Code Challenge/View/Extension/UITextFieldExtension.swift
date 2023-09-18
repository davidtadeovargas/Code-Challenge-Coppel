//
//  UITextFieldExtension.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import Foundation
import UIKit

extension UITextField{

    func isEmpty() -> Bool{
        return self.text==""
    }
    
    func setOnTextChangeListener(onTextChanged :@escaping () -> Void){
        self.addAction(UIAction(){ action in
            
            onTextChanged()

        }, for: .editingChanged)
    }
}
