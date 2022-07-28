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
    weak var coordinator: SettingsCoordinator?
    struct Constants {
        static let rowHeight: CGFloat = 70
    }
    private var settingsModel: [SettingsModel] {
        return SettingsViewModel.configureSettingsSections()
    }
    private var currentUser: User {
        return SettingsViewModel().currentUser
    }
    
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
        constraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchHeaderViewData), name: Notification.Name("login"), object: nil)
    }

//MARK: - Configure
    private func configureHeaderView() {
        headerView = SettingsHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: 150))
        headerView?.delegate = self
        guard let headerView = headerView else {return}
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        fetchHeaderViewData()
    }
    
    @objc private func fetchHeaderViewData() {
        guard let headerView = headerView else {return}
        Task {
            let viewModel = try await SettingsHeaderViewModel.fetchData(user: currentUser)
            headerView.configure(with: viewModel)
        }
    }
    
    private func configureTableView() {
        view.addSubview(settingsTableView)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.separatorColor = UIColor.clear
    }
    
//MARK: - Actions
    
    private func presentProfilePage() {
        coordinator?.tappedOnProfilePageCell(user: currentUser)
    }
    
    ///Called when user clicks on the help cell
    private func presentHelpPage(){
        coordinator?.tappedOnHelpPageCell(sender: self)
    }
    
    private func presentSettingsAndPrivacyPage() {
        coordinator?.tappedOnSettingsAndPrivacyPage()
    }
    
    private func didTapSignOut() {
        coordinator?.tappedSignOut(sender: self)
    }
}

//MARK: - TableView Methods

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.identifier,
            for: indexPath
        ) as? SettingsTableViewCell
        else {return UITableViewCell()}
        
        cell.configure(with: settingsModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: presentProfilePage()
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

//MARK: - Settings Header Methods
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

//MARK: - Constraints
extension SettingsViewController {
    private func constraints() {
        guard let headerView = headerView else {return}
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 70),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 150),
            headerView.widthAnchor.constraint(equalToConstant: view.width)
        ]
        let settingsTableViewConstraints = [
            settingsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.safeAreaInsets.bottom)
        ]
        NSLayoutConstraint.activate(settingsTableViewConstraints)
        NSLayoutConstraint.activate(headerViewConstraints)
    }
}
