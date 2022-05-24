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
    
    private var searchResultTweets: [TweetModel] = []
    
    private let searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
 
//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchResultsTableView()
        view.backgroundColor = .clear
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsTableView.frame = CGRect(x: 0, y: 50, width: view.width, height: view.height - 30)
    }
    
    private func configureSearchResultsTableView() {
        view.addSubview(searchResultsTableView)
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }
    
    func update(with results: [TweetModel]) {
        searchResultTweets = results
        searchResultsTableView.reloadData()
    }
}

//MARK: - TableView Methods

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell
        else {return UITableViewCell()}
        
        cell.configure(with: searchResultTweets[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
}
