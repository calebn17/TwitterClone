//
//  Notifications_Mentions_TableViewCell.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/19/22.
//

import UIKit

final class Notifications_Mentions_TableViewCell: UITableViewCell {

    static let identifier = "Notifications_Mentions_TableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
