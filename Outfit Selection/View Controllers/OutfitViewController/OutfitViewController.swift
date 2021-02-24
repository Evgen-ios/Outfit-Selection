//
//  OutfitViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

class OutfitViewController: UIViewController {
    // MARK: - Static Constants
    static let loadingMessage = "Loading..."
    
    // MARK: - Outlets
    @IBOutlet var likeButtons: [UIButton]!
    @IBOutlet var scrollViews: [PinnableScrollView]!
    
    // MARK: - Stored Properties
    var assetCount = 0
    var brandNames = [String]()
    var priceButtonItem: UIBarButtonItem!
    var diceButtonItem: UIBarButtonItem!
    
    /// Gender selected on female male screen
    var gender = Gender.other
    
    var selectedAction = UIBarButtonItem.SystemItem.cancel
    var selectedButtonIndex: Int?
    
    // MARK: - Computed Properties
    var itemCount: Int {
        scrollViews.reduce(0) { $0 + $1.itemCount }
    }
    
    var price: Double? {
        var amount = 0.0
        for scrollView in scrollViews {
            guard let itemPrice = scrollView.item?.price else { return nil }
            amount += itemPrice
        }
        return amount
    }
}
