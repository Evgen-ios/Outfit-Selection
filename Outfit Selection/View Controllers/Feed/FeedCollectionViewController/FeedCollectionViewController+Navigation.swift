//
//  FeedCollectionViewController+Navigation.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 20.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedCollectionViewController {
    // MARK: - UIViewController Inherited Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case FeedItemViewController.segueIdentifier:
            guard let feedHeader = sender as? FeedSectionHeaderView else {
                debug("Can't cast \(String(describing: sender)) to \(FeedSectionHeaderView.self)")
                return
            }
            
            guard let feedItemViewController = segue.destination as? FeedItemViewController else {
                debug("Can't cast \(segue.destination) to \(FeedItemViewController.self)")
                return
            }
            
            let kind = feedHeader.kind
            feedItemViewController.configure(kind, with: items[kind], named: feedHeader.title)
            
        case ItemViewController.segueIdentifier:
            // Make sure feed item was clicked
            guard let feedItem = sender as? FeedItem else {
                debug("Can't cast \(String(describing: sender)) to \(FeedItem.self)")
                return
            }
            
            // Make sure we segue to item view controller
            guard let itemViewController = segue.destination as? ItemViewController else {
                debug("Can't cast \(segue.destination) to \(ItemViewController.self)")
                return
            }
            
            // Configure item view controller with feed item and its image
            itemViewController.configure(with: feedItem.item, image: feedItem.itemImageView.image)
            
        default:
            debug("WARNING: unknown segue id \(String(describing: segue.identifier))")
        }
    }
}
