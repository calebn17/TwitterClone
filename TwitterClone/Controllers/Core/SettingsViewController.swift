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
    
 //MARK: - Properties
    
    struct Constants {
        static let rowHeight: CGFloat = 70
    }
    private var settingsModel: [SettingsModel] = []
    
//MARK: - SubViews
    private var headerView: SettingsHeaderView?
    
    private let settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = false
        title = nil
        configureHeaderView()
        configureTableView()
        configureSettingsSections()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView?.userHandleButton.setTitle(UserDefaults.standard.string(forKey: "userHandle"), for: .normal)
        headerView?.userNameButton.setTitle(UserDefaults.standard.string(forKey: "username"), for: .normal)
    }

//MARK: - Configure
    private func configureHeaderView() {
        headerView = SettingsHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: 150))
        headerView?.delegate = self
        guard let headerView = headerView else {return}
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 70),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 150),
            headerView.widthAnchor.constraint(equalToConstant: view.width)
        ]
        NSLayoutConstraint.activate(headerViewConstraints)
    }
    
    private func configureTableView() {
        view.addSubview(settingsTableView)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.separatorColor = UIColor.clear
        guard let headerView = headerView else {return}
        
        let settingsTableViewConstraints = [
            settingsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.safeAreaInsets.bottom)
        ]
        NSLayoutConstraint.activate(settingsTableViewConstraints)
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
    
//MARK: - Actions
    
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
    
    private func didTapSignOut() {
        
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            AuthManager.shared.logOut {[weak self] success in
                DispatchQueue.main.async {
                    if success {
                        //present login screen
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self?.present(loginVC, animated: true) {
                            //completion handler here makes the app go back to the homescreen (behind the login screen) and makes the selected tab match the homescreen
                            self?.navigationController?.popToRootViewController(animated: false)
                            self?.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        //error when logging out
                        fatalError("Could not log out user")
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
        case 11: didTapSignOut()
        default: break
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}

extension SettingsViewController: SettingsHeaderViewDelegate {
    func didTapAccountsButton() {
        print("did tap accounts button")
        DispatchQueue.main.async { [weak self] in
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
            
            self?.present(actionSheet, animated: true, completion: nil)
            
        }
        
    }
    
    
}
