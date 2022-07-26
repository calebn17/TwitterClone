//
//  SearchViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit

//MARK: - Protocol
protocol SearchViewControllerDelegate: AnyObject {
    func didTapPublishTweet(tweetBody: String, publishedFromSearchVC sender: SearchViewController)
}

///Search Screen
final class SearchViewController: UIViewController {

//MARK: - Properties
    weak var delegate: SearchViewControllerDelegate?
    private let searchResultTweets: [TweetViewModel] = []

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
    
    private let addTweetButton: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemCyan
        button.tintColor = .white
        button.layer.cornerRadius = K.addButtonSize/2
        return button
    }()

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = false
        configureSearchBar()
        configureNavbar()
        configureAddTweetButton()
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
        if searchResultTweets.isEmpty {
            view.addSubview(searchTableViewPlaceholderImage)
            
            let searchTableViewPlacholderImageConstraints = [
                searchTableViewPlaceholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                searchTableViewPlaceholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
            NSLayoutConstraint.activate(searchTableViewPlacholderImageConstraints)
        }
    }
    
    private func configureAddTweetButton() {
        view.addSubview(addTweetButton)
        addTweetButton.addTarget(self, action: #selector(didTapAddTweetButton), for: .touchUpInside)
        let addTweetButtonConstraints = [
            addTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            addTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            addTweetButton.heightAnchor.constraint(equalToConstant: K.addButtonSize),
            addTweetButton.widthAnchor.constraint(equalToConstant: K.addButtonSize)
        ]
        NSLayoutConstraint.activate(addTweetButtonConstraints)
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
    
//MARK: - Actions
    
    @objc private func didTapProfileIcon() {
        //navigates to profile feed
    }
    
    @objc private func didTapAddTweetButton() {
        //present the addTweetViewController
        let vc = AddTweetViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - SearchBar Methods

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
        
        //Fetching the Search Results data
        Task{
            do {
                let results = try await SearchViewModel.fetchSearchData(query: query)
                resultsController.update(with: results)
            }
            catch {
                print("Request to search failed")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else {return}
        resultsController.update(with: [])
    }
}

extension SearchViewController: AddTweetViewControllerDelegate {
    func didTapTweetPublishButton(tweetBody: String) {
        
        delegate?.didTapPublishTweet(tweetBody: tweetBody, publishedFromSearchVC: self)
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 0

    }
}
