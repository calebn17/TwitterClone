//
//  ReusableImageView.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/26/22.
//

import UIKit

class CustomImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
