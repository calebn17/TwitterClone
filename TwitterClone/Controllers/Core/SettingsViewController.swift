//
//  SettingsViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit
import SafariServices

///Settings Screen
final class SettingsViewController: UIViewController {
    
 //MARK: - Setup
    
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

//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil
        view.addSubview(settingsTableView)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.separatorColor = UIColor.clear
        configureSettingsSections()
        
        configureHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTableView.frame = view.bounds
    }

//MARK: - Configure Methods
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
    
    private func configureHeaderView() {
        headerView = SettingsHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        settingsTableView.tableHeaderView = headerView
        headerView?.delegate = self
    }
    
//MARK: - Action Methods
    
    ///Called when user clicks on the help cell
    private func presentHelpPage(){
        
        guard let url = URL(string: "https://help.twitter.com/en") else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    private func presentSettingsAndPrivacyPage() {
        let vc = SettingsAndPrivacyViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

//MARK: - TableView Methods

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
        
        switch indexPath.row {
        case 0: break
        case 1: break
        case 2: break
        case 3: break
        case 4: break
        case 5: break
        case 6: break
        case 7: break
        case 8: break
        case 9: presentSettingsAndPrivacyPage()
        case 10: presentHelpPage()
        case 11:break
        default: break
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}

extension SettingsViewController: SettingsHeaderViewDelegate {
    func didTapAccountsButton() {
        
        //WIP
        let actionSheet = UIAlertController(title: "Accounts", message: "Switch Accounts?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Current User", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Create Account", style: .default, handler: { _ in
            //push account creation form
            print("account creation form")
        }))
        actionSheet.addAction(UIAlertAction(title: "Add an Existing Account", style: .default, handler: { _ in
            //push existing account form
            print("add existing account form")
        }))
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
}
