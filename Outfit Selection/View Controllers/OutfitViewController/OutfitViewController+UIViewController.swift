//
//  ViewController+UIViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIViewController
extension OutfitViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ItemViewController" else { return }
        guard let destination = segue.destination as? ItemViewController else { return }
        guard let recognizer = sender as? UIGestureRecognizer else { return }
        guard let scrollView = recognizer.view as? PinnableScrollView else { return }
        guard let imageView = scrollView.getImageView() else { return }
        
        destination.image = imageView.image
        destination.itemIndex = imageView.tag
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        scrollViews.forEach { $0.setEditing(editing) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assetCount = 0 // ItemManager.shared.loadImagesFromAssets(into: scrollViews)
        scrollViews.forEach { $0.delegate = self }
        setupGestures()
        setupUI()
        presentGenderViewController()
        
        // DEBUG: List of categories
        NetworkManager.shared.getCategories { categories in
            guard let categories = categories?.sorted(by: { $0.name < $1.name }) else { return }
            
            for category in categories {
                print("\(category.id)\t\(category.name)")
            }
            
            debug("categories.count = \(categories.count)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollViews.forEach { $0.scrollToCurrentElement() }
        }
    }
}
