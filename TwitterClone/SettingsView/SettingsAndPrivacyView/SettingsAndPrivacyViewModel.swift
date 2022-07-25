//
//  SettingsAndPrivacyViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/20/22.
//

import Foundation

struct SettingsAndPrivacyViewModel {
    let title: String
    let icon: String
    let description: String
    
    static func configureModel() -> [SettingsAndPrivacyViewModel] {
        
        var models = [SettingsAndPrivacyViewModel]()
        
        models.append(
            SettingsAndPrivacyViewModel(
                title: "Your Account",
                icon: "person",
                description: SettingsAndPrivacyStrings.yourAccount
            )
        )
        models.append(
            SettingsAndPrivacyViewModel(
                title: "Security and Account Access",
                icon: "lock",
                description: SettingsAndPrivacyStrings.Security
            )
        )
        models.append(
            SettingsAndPrivacyViewModel(
                title: "Monetization",
                icon: "dollarsign.square",
                description: SettingsAndPrivacyStrings.Monetization
            )
        )
        models.append(
            SettingsAndPrivacyViewModel(
                title: "Twitter Blue",
                icon: "b.square",
                description: SettingsAndPrivacyStrings.TwitterBlue
            )
        )
        models.append(
            SettingsAndPrivacyViewModel(
                title: "Privacy and Safety",
                icon: "shield.lefthalf.filled",
                description: SettingsAndPrivacyStrings.PrivacyAndSafety
            )
        )
        models.append(
            SettingsAndPrivacyViewModel(
                title: "Notifications",
                icon: "bell",
                description: SettingsAndPrivacyStrings.Notifications
            )
        )
        models.append(
            SettingsAndPrivacyViewModel(
                title: "Accessibility, display, and languages",
                icon: "figure.stand",
                description: SettingsAndPrivacyStrings.Accesibility
            )
        )
        models.append(
            SettingsAndPrivacyViewModel(
                title: "Additional Resources",
                icon: "ellipsis.circle",
                description: SettingsAndPrivacyStrings.Resources
            )
        )
        return models
    }
}
