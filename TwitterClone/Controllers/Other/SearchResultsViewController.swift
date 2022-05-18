//
//  SearchResultsViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/9/22.
//

import UIKit
///Search Results Screen
class SearchResultsViewController: UIViewController {

//MARK: - Setup
    
    private var searchResultTweets: [Tweet] = []
    
    private let searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
 
//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchResultsTableView)
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        view.backgroundColor = .clear
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsTableView.frame = view.bounds
    }
    
    func update(with results: [Tweet]) {
        searchResultTweets = results
        searchResultsTableView.reloadData()
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell
        else {return UITableViewCell()}
        
        let userName = searchResultTweets[indexPath.row].id ?? ""
        let tweetBody = searchResultTweets[indexPath.row].text ?? ""
        
        cell.configure(with: HomeTweetViewCellViewModel(id: nil ,userName: userName, userAvatar: nil, tweetBody: tweetBody, url_link: nil))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
