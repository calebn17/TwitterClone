//
//  SearchViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit

///Search Screen
final class SearchViewController: UIViewController {

//MARK: - Properties
    weak var coordinator: SearchCoordinator?
    private var viewModel = SearchViewModel()
    private let searchResultTweets: [TweetViewModel] = []
    private var currentUser = SearchViewModel().currentUser

//MARK: - SubViews
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Search Twitter"
        vc.searchBar.searchBarStyle = .default
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let searchTableViewPlaceholderImage: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        let image = UIImage(systemName: "rectangle.and.text.magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 100))
        imageView.image = image
        imageView.tintColor = .label
        return imageView
    }()
    
    private let twitterIcon: CustomImageView = {
        let icon = CustomImageView(frame: .zero)
        icon.image = UIImage(named: "twitterLogo")
        icon.contentMode = .scaleAspectFit
        return icon
    }()

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = false
        configureSearchBar()
        configureNavbar()
        configurePlaceholderImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

//MARK: - Configure
    
    private func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func configurePlaceholderImageView() {
        view.addSubview(searchTableViewPlaceholderImage)
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .done,
            target: self,
            action: #selector(didTapProfileIcon)
        )
        navigationItem.titleView = twitterIcon
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = ""
    }
    
//MARK: - Networking
    
    private func fetchData(with query: String) {
        Task{
            do {
                try await viewModel.fetchSearchData(query: query)
            }
            catch {
                print("Request to search failed")
            }
        }
    }
    
//MARK: - Actions
    
    @objc private func didTapProfileIcon() {
        coordinator?.tappedOnProfileIcon(user: currentUser)
    }
}

//MARK: - SearchBar Methods

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UITextFieldDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //required by UISearchResultsUpdating
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Setting the searchResultsController (built-in) as our custom SearchResultsViewController
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              //Making sure there is text, and that the input isn't just empty white spaces
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        
        fetchData(with: query)
        
        // Update resultsVC UI
        viewModel.searchData.bind { tweets in
            guard let tweets = tweets else {return}
            resultsController.updateUI(with: tweets)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else {return}
        resultsController.updateUI(with: [])
        configurePlaceholderImageView()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else {return false}
        DispatchQueue.main.async {[weak self] in
            resultsController.updateUI(with: [])
            self?.configurePlaceholderImageView()
        }
        return true
    }
}
