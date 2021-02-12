//
//  Utilities.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 26/01/21.
//


import UIKit

class Utilities {
    
    func setLoginButtonOnKeyboard(button: UIButton, textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let freeBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(customView: button)
        toolBar.items = [freeBarButton, doneBarButton]
        textField.inputAccessoryView = toolBar
        
    }
    
}
