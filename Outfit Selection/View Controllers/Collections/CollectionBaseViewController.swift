//
//  CollectionBaseViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class CollectionBaseViewController: UIViewController {

    // MARK: - Actions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        debug()
        dismiss(animated: true)
    }
}
