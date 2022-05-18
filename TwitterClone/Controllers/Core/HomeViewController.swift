//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit

///Home Screen
final class HomeViewController: UIViewController {

//MARK: - Setup
    
    struct Constants {
        static let addButtonSize: CGFloat = 60
    }
    
    private var tweets: [Tweet] = []
    
    private let twitterIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "twitterLogo")
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private let addTweetButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
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

//MARK: - View Methods
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
        
        addTweetButton.addTarget(self, action: #selector(didTapAddTweetButton), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = view.bounds
    }
    
//MARK: - Configure Methods
    
    private func configureNavbar() {
        var image = UIImage(named: "twitterLogo")
        image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //forces xcode to use the original image (logo comes out as different color if this isnt done)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"),
                                                            style: .done,
                                                            target: self,
                                                            action: nil)
        navigationItem.titleView = twitterIcon
        
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
    
//MARK: - Action Methods
    
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
    
    @objc private func didTapAddTweetButton() {
        //present the addTweetViewController
        let vc = AddTweetViewController()
        vc.modalPresentationStyle = .fullScreen
        //navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - TableView Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell
        else {return UITableViewCell()}
        
        let id = tweets[indexPath.row].id ?? "unknown user"
        let text = tweets[indexPath.row].text ?? "missing body"
        
        cell.delegate = self
        cell.configure(with: HomeTweetViewCellViewModel(id: nil, userName: id, userAvatar: nil, tweetBody: text, url_link: nil))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - TweetTableViewCellDelegate Methods
extension HomeViewController: TweetTableViewCellDelegate {
    
    func didTapCommentButton() {
        let vc = AddCommentViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func didTapRetweet(with model: HomeTweetViewCellViewModel, completion: @escaping (Bool) -> Void) {
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Retweet", style: .default, handler: { _ in
            print("retweet")
            completion(true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Quote", style: .default, handler: {[weak self] _ in
            let vc = AddTweetViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func didTapLikeButton(liked: Bool) {
        //
    }
    
    func didTapShareButton() {
        let firstAction = "This Tweet"
        let shareAction = UIActivityViewController(activityItems: [firstAction], applicationActivities: nil)
        shareAction.isModalInPresentation = true
        present(shareAction, animated: true, completion: nil)
    }
    
    
}
