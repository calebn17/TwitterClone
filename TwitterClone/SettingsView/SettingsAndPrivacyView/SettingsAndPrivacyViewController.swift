//
//  SettingsAndPrivacyViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/18/22.
//

import UIKit

final class SettingsAndPrivacyViewController: UIViewController {
    
//MARK: - Properties
    private var models: [SettingsAndPrivacyViewModel] {
        return SettingsAndPrivacyViewModel.configureModel()
    }
    
//MARK: - SubViews
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsAndPrivacyTableViewCell.self, forCellReuseIdentifier: SettingsAndPrivacyTableViewCell.identifier)
        return tableView
    }()
    
//MARK: - Lifecycle
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
    
//MARK: - Configure
    private func configureNavbar() {
        navigationItem.title = "Settings And Privacy"
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
    }
    
    
}

//MARK: - TableView Methods
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
        
        switch indexPath.row {
        case 0: break
        case 1: break
        case 2: break
        case 3: break
        case 4: break
        case 5: break
        case 6: break
        case 7: break
        default: break
        }
    }
}
