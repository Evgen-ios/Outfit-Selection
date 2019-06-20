//
//  ViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var clothesStackView: UIStackView!
    @IBOutlet var scrollViews: [UIScrollView]!
    @IBOutlet var buttonsStackView: UIStackView!
    @IBOutlet var buttons: [UIButton]!
    
    var selectedAction = UIBarButtonItem.SystemItem.cancel
    var selectedButtonIndex: Int?
}
