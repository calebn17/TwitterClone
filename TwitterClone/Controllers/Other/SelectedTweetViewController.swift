//
//  SelectedTweetViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/25/22.
//

import UIKit

class SelectedTweetViewController: UIViewController {

    private let selectedTweetTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    
    private let headerUIView: SelectedTweetHeaderView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedTweetTableView.tableHeaderView = headerUIView
        
    }
    

   

}
