//
//  Constants.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/9/22.
//

import Foundation
import UIKit

struct K {
    static let APIKey = "cCN0pLVq34O2Ij3Kz1pm9kqVu"
    static let APIKeySecret = "HE7rTaq81U7FkTGSbh9m9PNeEvcnWJRZelESvQlscwODpQbJ6m"
    static let bearerToken =  "AAAAAAAAAAAAAAAAAAAAAFgvcQEAAAAAamVnD%2F%2BquEtsJDgEvHXIUcuT7VA%3DefoIcmcEiubKHIHkppwq41fOY2lWMXtHyguAHMF142mM3EZvSh"
    static let baseURL = "https://api.twitter.com/2/"
    static let userImageSize: CGFloat = 40.0
    static let addButtonSize: CGFloat = 60
}

struct SettingsAndPrivacyStrings {
    static let yourAccount = "See information about your account, download an archive of your data, or learn about your account deactivation options."
    static let Security = "This is a mock description so that I can see how everything looks when put in this cell"
    static let Monetization = "This is a mock description so that I can see how everything looks when put in this cell"
    static let TwitterBlue = "This is a mock description so that I can see how everything looks when put in this cell"
    static let PrivacyAndSafety = "This is a mock description so that I can see how everything looks when put in this cell"
    static let Notifications = "This is a mock description so that I can see how everything looks when put in this cell"
    static let Accesibility = "This is a mock description so that I can see how everything looks when put in this cell"
    static let Resources = "This is a mock description so that I can see how everything looks when put in this cell"
}

struct Cache {
    static let username = "username"
    static let email = "email"
    static let userHandle = "userHandle"
}
