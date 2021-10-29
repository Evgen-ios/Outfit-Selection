//
//  ViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension OutfitViewController {
    /// Called when hanger bar button in navigation brat is tapped
    /// - Parameter sender: the hanger bar button which was tapped
    @IBAction func hangerBarButtonItemTapped(_ sender: Any) {
        showHangerBubble = false
        showHangerButtons.toggle()
    }
    
    /// Called when the user taps hanger bubble
    @objc func hangerBubbleTapped() {
        showHangerBubble = false
        showShuffleBubble = true
        showBubbles()
    }
    
    /// Called when one of individual hanger buttons in a scroll view is tapped
    /// - Parameter sender: the hanger button which was tapped
    @IBAction func hangerButtonTapped(_ sender: UIButton) {
        // Find the index of scroll view whose hanger button is tapped
        guard let selectedIndex = hangerButtons.firstIndex(of: sender) else { return }
        
        // Toggle (pin/unpin) selected scroll view
        scrollViews[selectedIndex].togglePinned()
        
        // Disable refresh button if all scroll views are pinned
        shuffleButton.isEnabled = !scrollViews.allPinned
        
        // Update hanger buttons opacity
        configureHangerButtons()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        // Set most recent like/dislike to outfits
        Wishlist.tabSuggested = .outfit
        
        // Dislike if we already liked it, or like if we didn't
        if Wishlist.contains(visibleItems) == true {
            sender.isSelected = false
            Wishlist.remove(visibleItems)
        } else {
            let controller = storyboard?.instantiateViewController(
                withIdentifier: OccasionsPopupViewController.storyboardId
            )
            guard let occasionsPopupViewController = controller as? OccasionsPopupViewController else { return }
            occasionsPopupViewController.items = visibleItems
            present(occasionsPopupViewController, animated: true)
        }
    }
    
    @IBAction func occasionButtonTapped(_ sender: OccasionButton) {
        // Hide bubles when we started occasion selection
        hideBubbles()
        
        // Scroll to tapped occasion
        guard let occasion = sender.occasion else { return }
        scrollTo(occasion: occasion)
    }
    
    /// Move to occasions view controller when left screen edge is panned
    /// - Parameter sender: left screen edge pan gesture recognizer
    @IBAction func screenEdgePanned(_ sender: UIScreenEdgePanGestureRecognizer) {
        // Make sure the gesture has ended
        guard sender.state == .ended else { return }
        
        // Get navigation controller on top of tab bar controller
        guard let welcomeNavigationController = tabBarController?.navigationController else {
            debug("WARNING: Can't find navigation controller on top of", tabBarController)
            return
        }
        
        // Get occasions, brands, or gender view controller
        guard let popViewController = welcomeNavigationController.findViewController(
            ofType: OccasionsViewController.self
        ) ?? welcomeNavigationController.findViewController(
            ofType: BrandsViewController.self
        ) ?? welcomeNavigationController.findViewController(
            ofType: GenderViewController.self
        ) else {
            debug(
                "WARNING: Can't find \(OccasionsViewController.self)",
                "or \(BrandsViewController.self) or \(GenderViewController.self) in",
                welcomeNavigationController
            )
            return
        }
        
        // Pop to occasions, brands, or gender view controller
        welcomeNavigationController.popToViewController(popViewController, animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        // Get the images and check that all of them are not nil
        let imageViews = scrollViews.compactMap { $0.getImageView() }
        let images = imageViews.compactMap { $0.image }
        let items = imageViews.compactMap { $0.item }
        guard images.count == scrollViews.count && images.count == items.count else { return }
        
        // Create a view for screenshot
        shareView = ShareView.instanceFromNib()
        shareView?.configureContent(with: images, items: items)
        
        // Segue to share view controller
        performSegue(withIdentifier: "shareViewControllerSegue", sender: self)
    }
    
    /// Called when the user taps refresh bubble
    @objc func shuffleBubbleTapped() {
        showShuffleBubble = false
    }
    
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        showShuffleBubble = false
        scrollToRandomItems()
    }
}
