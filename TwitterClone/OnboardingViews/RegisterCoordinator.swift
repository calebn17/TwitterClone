//
//  RegisterCoordinator.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/28/22.
//

import Foundation
import UIKit

class RegisterCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var sender: AnyObject
    
    init(navigationController: UINavigationController, sender: AnyObject) {
        self.navigationController = navigationController
        self.sender = sender
    }
    
    func start() {
        let vc = RegisterViewController()
        vc.delegate = sender as? RegisterViewControllerDelegate
        vc.coordinator = self
        let navVC = UINavigationController(rootViewController: vc)
        sender.present(navVC, animated: true, completion: nil)
    }
    
    func tappedOnProfileImage(sender: RegisterViewController) {
        let sheet = UIAlertController(title: "Change your profile picture", message: "Update your profile picture", preferredStyle: .actionSheet)
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
    
    func registerSuccessfully(sender: RegisterViewController) {
        sender.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
        sender.delegate?.didRegisterSuccessfully()
    }
}
