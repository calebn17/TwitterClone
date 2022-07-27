//
//  Coordinator.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/27/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var childrenCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
