//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureNavbar()
        
        
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "twitterLogo")
        image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //forces xcode to use the original image (logo comes out as different color if this isnt done)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: image, style: .done, target: self, action: nil),
            
            ]
        
//        navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
//            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
//        ]
        navigationController?.navigationBar.tintColor = .white
    }
    

  

}
