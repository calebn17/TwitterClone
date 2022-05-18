//
//  SearchViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchResultTweets: [Tweet] = []
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Search Twitter"
        vc.searchBar.searchBarStyle = .default
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let searchTableViewPlaceholderImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "rectangle.and.text.magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 100))
        imageView.image = image
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        configureNavbar()
        
        if searchResultTweets.isEmpty {
            view.addSubview(searchTableViewPlaceholderImage)
            configurePlaceholderConstraints()
        }
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchTableView.frame = view.bounds
    }
    
    private func configurePlaceholderConstraints() {
        let searchTableViewPlacholderImageConstraints = [
            searchTableViewPlaceholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTableViewPlaceholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(searchTableViewPlacholderImageConstraints)
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "twitterLogo")
        image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //forces xcode to use the original image (logo comes out as different color if this isnt done)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: image, style: .done, target: self, action: nil),
            ]
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = ""
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        return cell
    }
    
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Setting the searchResultsController (built-in) as our custom SearchResultsViewController
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              //Making sure there is text, and that the input isn't just empty white spaces
                let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
//        //Using a delegate to push the search results view onto the SearchViewController
//        resultsController.delegate = self
        
        //Fetching the Search Results data
        APICaller.shared.getSearch(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    //updating the resultsController(SearchResultsViewController) with the data
                    resultsController.update(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else {return}
        resultsController.update(with: [])
    }

}
