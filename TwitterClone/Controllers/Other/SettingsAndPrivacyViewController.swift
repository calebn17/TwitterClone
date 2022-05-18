//
//  SettingsAndPrivacyViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/18/22.
//

import UIKit

class SettingsAndPrivacyViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return tableView
    }()
    
    private var models = [SettingsAndPrivacyModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavbar()
        configureTableView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureNavbar() {
        navigationItem.title = "Settings"
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureModels() {
        models.append(SettingsAndPrivacyModel(title: "Your Account", icon: "person", description: ""))
        models.append(SettingsAndPrivacyModel(title: "Security and Account Access", icon: "lock", description: ""))
        models.append(SettingsAndPrivacyModel(title: "Monetization", icon: "dollarsign.square", description: ""))
        models.append(SettingsAndPrivacyModel(title: "Twitter Blue", icon: "b.square", description: ""))
        models.append(SettingsAndPrivacyModel(title: "Privacy and Safety", icon: "shield.lefthalf.filled", description: ""))
        models.append(SettingsAndPrivacyModel(title: "Notifications", icon: "bell", description: ""))
        models.append(SettingsAndPrivacyModel(title: "Accessibility, display, and languages", icon: "figure.stand", description: ""))
        models.append(SettingsAndPrivacyModel(title: "Additional Resources", icon: "ellipsis.circle", description: ""))
    }
    
    
}

extension SettingsAndPrivacyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsAndPrivacyTableViewCell.identifier, for: indexPath) as? SettingsAndPrivacyTableViewCell
        else {return UITableViewCell()}
        
        return cell
    }
}
