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
    
    private var tweet: TweetModel?
    private var headerView: SelectedTweetHeaderView?
    
    init(with tweet: TweetModel){
        self.tweet = tweet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tweet"
        configureHeaderView()
    }
    
    private func configureHeaderView() {
        headerView = SelectedTweetHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: 0))
        selectedTweetTableView.tableHeaderView = headerView
        guard let headerView = headerView, let tweet = self.tweet else {return}
        view.addSubview(headerView)
        headerView.configure(with: tweet)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 120),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.widthAnchor.constraint(equalToConstant: view.width)
        ]
        NSLayoutConstraint.activate(headerViewConstraints)
    }
    
   

   

}
