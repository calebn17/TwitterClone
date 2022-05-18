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
        tableView.register(SettingsAndPrivacyTableViewCell.self, forCellReuseIdentifier: SettingsAndPrivacyTableViewCell.identifier)
        return tableView
    }()
    
    private var models = [SettingsAndPrivacyModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavbar()
        configureTableView()
        configureModels()
        
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
        tableView.separatorColor = UIColor.clear
    }
    
    private func configureModels() {
        models.append(SettingsAndPrivacyModel(title: "Your Account", icon: "person", description: "This is a mock description so that I can see how everything looks when put in this cell"))
        models.append(SettingsAndPrivacyModel(title: "Security and Account Access", icon: "lock", description: "This is a mock description so that I can see how everything looks when put in this cell"))
        models.append(SettingsAndPrivacyModel(title: "Monetization", icon: "dollarsign.square", description: "This is a mock description so that I can see how everything looks when put in this cell"))
        models.append(SettingsAndPrivacyModel(title: "Twitter Blue", icon: "b.square", description: "This is a mock description so that I can see how everything looks when put in this cell"))
        models.append(SettingsAndPrivacyModel(title: "Privacy and Safety", icon: "shield.lefthalf.filled", description: "This is a mock description so that I can see how everything looks when put in this cell"))
        models.append(SettingsAndPrivacyModel(title: "Notifications", icon: "bell", description: "This is a mock description so that I can see how everything looks when put in this cell"))
        models.append(SettingsAndPrivacyModel(title: "Accessibility, display, and languages", icon: "figure.stand", description: "This is a mock description so that I can see how everything looks when put in this cell"))
        models.append(SettingsAndPrivacyModel(title: "Additional Resources", icon: "ellipsis.circle", description: "This is a mock description so that I can see how everything looks when put in this cell"))
    }
    
    
}

extension SettingsAndPrivacyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsAndPrivacyTableViewCell.identifier, for: indexPath) as? SettingsAndPrivacyTableViewCell
        else {return UITableViewCell()}
        
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
