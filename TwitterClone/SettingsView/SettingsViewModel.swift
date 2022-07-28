//
//  SettingsViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/20/22.
//

import Foundation

struct SettingsModel {
    let title: String
    let icon: String?
}

struct SettingsViewModel {
    
    var currentUser: User { return DatabaseManager.shared.currentUser }
    
    static func configureSettingsSections() -> [SettingsModel] {
        var settingsModel = [SettingsModel]()
        
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
        
        return settingsModel
    }
}


