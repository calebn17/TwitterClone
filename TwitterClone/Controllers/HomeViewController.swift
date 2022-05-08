//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var tweets: [Tweet] = []
    
    private let homeFeedTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTweetTableViewCell.self, forCellReuseIdentifier: HomeTweetTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavbar()
        title = "Home"
        view.addSubview(homeFeedTableView)
        
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        
        fetchData()
        
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
    
    private func fetchData() {
        APICaller.shared.getSearch { [weak self] results in
            switch results {
            case .success(let tweets):
                DispatchQueue.main.async {
                    self?.tweets = tweets
                    self?.homeFeedTableView.reloadData()
                    print("successfully got tweets")
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTweetTableViewCell.identifier, for: indexPath) as? HomeTweetTableViewCell
        else {return UITableViewCell()}
        
        let id = tweets[indexPath.row].id ?? "unknown user"
        print(id)
        let text = tweets[indexPath.row].text ?? "missing body"
        
        cell.configure(with: HomeTweetViewCellViewModel(userName: id, userAvatar: nil, tweetBody: text))
        
        return cell
    }
    
}
