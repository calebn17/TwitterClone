//
//  SearchResultsViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/9/22.
//

import UIKit

///Search Results Screen
class SearchResultsViewController: UIViewController {

//MARK: - Properties
    private var searchResultTweets: [TweetViewModel] = []
    
//MARK: - SubViews
    private let searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
 
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchResultsTableView()
        view.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsTableView.frame = CGRect(x: 0, y: 50, width: view.width, height: view.height - 30)
    }

//MARK: - Configure
    
    private func configureSearchResultsTableView() {
        view.addSubview(searchResultsTableView)
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }
    
    func update(with results: [TweetViewModel]) {
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
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
