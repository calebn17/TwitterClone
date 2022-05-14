//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    struct Constants {
        static let addButtonSize: CGFloat = 60
    }
    
    private var tweets: [Tweet] = []
    
    private let addTweetButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemCyan
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.addButtonSize/2
        button.layer.masksToBounds = true
        return button
    }()
    
    private let homeFeedTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavbar()
        title = nil
        view.addSubview(homeFeedTableView)
        view.addSubview(addTweetButton)
        
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        
        fetchData()
        configureConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = view.bounds
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
    
    private func configureConstraints() {
        let addTweetButtonConstraints = [
            addTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            addTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            addTweetButton.heightAnchor.constraint(equalToConstant: Constants.addButtonSize),
            addTweetButton.widthAnchor.constraint(equalToConstant: Constants.addButtonSize)
        ]
        NSLayoutConstraint.activate(addTweetButtonConstraints)
    }
    
    private func fetchData() {
        APICaller.shared.getSearch(with: "bitcoin") { [weak self] results in
            switch results {
            case .success(let tweets):
                DispatchQueue.main.async {
                    self?.tweets = tweets
                    self?.homeFeedTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell
        else {return UITableViewCell()}
        
        let id = tweets[indexPath.row].id ?? "unknown user"
        let text = tweets[indexPath.row].text ?? "missing body"
        
        cell.configure(with: HomeTweetViewCellViewModel(userName: id, userAvatar: nil, tweetBody: text))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
