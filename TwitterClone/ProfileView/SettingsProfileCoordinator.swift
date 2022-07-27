//
//  ProfileCoordinator.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/27/22.
//

import Foundation
import UIKit

class SettingsProfileCoordinator: Coordinator {
    weak var parentCoordinator: SettingsCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var currentUser: User { return ProfileViewModel().currentUser }
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ProfileViewController(with: currentUser)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func tappedEditButton(sender: ProfileViewController) {
        let vc = EditProfileViewController()
        vc.delegate = sender
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        sender.present(navVC, animated: true)
    }
    
    func tappedOnTweetCell(tweet: TweetViewModel) {
        let vc = SelectedTweetViewController(with: tweet)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func tappedOnProfilePicture(sender: ProfileViewController) {
        let sheet = UIAlertController(
            title: "Change your profile picture",
            message: "Update your profile picture",
            preferredStyle: .actionSheet
        )
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak sender] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = sender
                sender?.present(picker, animated: true)
            }
        }))
        sheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak sender] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = sender
                sender?.present(picker, animated: true)
            }
        }))
        sender.present(sheet, animated: true)
    }
    
}
