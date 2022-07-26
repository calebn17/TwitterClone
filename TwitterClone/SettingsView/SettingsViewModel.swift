//
//  SettingsViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/20/22.
//

import Foundation

struct SettingsViewModel {
    let title: String
    let icon: String?
    
    static func configureSettingsSections() -> [SettingsViewModel] {
        var settingsModel = [SettingsViewModel]()
        
        settingsModel.append(SettingsViewModel(title: "Profile", icon: "person"))
        settingsModel.append(SettingsViewModel(title: "Lists", icon: "list.bullet.rectangle"))
        settingsModel.append(SettingsViewModel(title: "Topics", icon: "text.bubble"))
        settingsModel.append(SettingsViewModel(title: "Bookmarks", icon: "bookmark"))
        settingsModel.append(SettingsViewModel(title: "TwitterBlue", icon: "b.square"))
        settingsModel.append(SettingsViewModel(title: "Moments", icon: "bolt"))
        settingsModel.append(SettingsViewModel(title: "Purchases", icon: "cart"))
        settingsModel.append(SettingsViewModel(title: "Monetization", icon: "dollarsign.square"))
        settingsModel.append(SettingsViewModel(title: "Twitter for Professionals", icon: "airplane"))
        settingsModel.append(SettingsViewModel(title: "Settings and privacy", icon: nil))
        settingsModel.append(SettingsViewModel(title: "Help Center", icon: nil))
        settingsModel.append(SettingsViewModel(title: "Sign Out", icon: nil))
        
        return settingsModel
    }
}


