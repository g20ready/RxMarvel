//
//  MainTabBarController.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 30/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ((viewControllers?[0] as? UINavigationController)?.viewControllers[0] as? CharactersViewController)?.viewModel = CharactersViewModel(charactersService: CharactersRepository.shared)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
    }

}
