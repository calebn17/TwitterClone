//
//  ReusableTextField.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/20/22.
//

import UIKit

class ReusableTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        leftViewMode = .always
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        
        backgroundColor = .systemBackground
        autocapitalizationType = .none
        autocorrectionType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
