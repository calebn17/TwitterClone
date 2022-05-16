//
//  SettingsViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit
import SafariServices

final class SettingsViewController: UIViewController {
    
    struct Constants {
        static let rowHeight: CGFloat = 70
    }
    
    private var settingsModel: [SettingsModel] = []
    
    private var headerView: SettingsHeaderView?
    
    private let settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil
        view.addSubview(settingsTableView)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        configureSettingsSections()
        
        headerView = SettingsHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        settingsTableView.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTableView.frame = view.bounds
    }
    
    private func configureSettingsSections() {
        settingsModel.append(SettingsModel(title: "Profile", icon: "person"))
        settingsModel.append(SettingsModel(title: "Lists", icon: "list.bullet.rectangle"))
        settingsModel.append(SettingsModel(title: "Topics", icon: "text.bubble"))
        settingsModel.append(SettingsModel(title: "Bookmarks", icon: "bookmark"))
        settingsModel.append(SettingsModel(title: "TwitterBlue", icon: "b.square"))
        settingsModel.append(SettingsModel(title: "Moments", icon: "bolt"))
        settingsModel.append(SettingsModel(title: "Purchases", icon: "cart"))
        settingsModel.append(SettingsModel(title: "Monetization", icon: "dollarsign.square"))
        
        settingsModel.append(SettingsModel(title: "Twitter for Professionals", icon: "airplane"))
        
        settingsModel.append(SettingsModel(title: "Settings and privacy", icon: nil))
        settingsModel.append(SettingsModel(title: "Help Center", icon: nil))
        settingsModel.append(SettingsModel(title: "Sign Out", icon: nil))
    }
    
    private func presentHelpPage(){
        
        guard let url = URL(string: "https://help.twitter.com/en") else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath)
                            as? SettingsTableViewCell
        else {return UITableViewCell()}
        
        cell.configure(with: settingsModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 10 {
            presentHelpPage()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
    
}
