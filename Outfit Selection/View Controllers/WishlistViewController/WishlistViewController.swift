//
//  WishlistViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionsButton: UIButton!
    @IBOutlet weak var collectionsUnderline: UIView!
    @IBOutlet weak var itemsButton: UIButton!
    @IBOutlet weak var itemsUnderline: UIView!
    @IBOutlet weak var outfitsButton: UIButton!
    @IBOutlet weak var outfitsUnderline: UIView!
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    
    // MARK: - Types
    enum TabSelected {
        case collections
        case items
        case outfits
    }
    
    // MARK: - Computed Properties
    /// Get outfit view controller
    var outfitViewController: OutfitViewController? {
        let navigationController = tabBarController?.viewControllers?.first as? UINavigationController
        return navigationController?.viewControllers.first as? OutfitViewController
    }
    
    /// Either items or outfits wishlist depending on whether the items tab is selected
    var wishlist: [Wishlist] {
        switch tabSelected {
        case .collections:
            return []
        case .items:
            return Wishlist.items
        case .outfits:
            return Wishlist.outfits
        }
    }
    
    /// Either items or outfit cell depending on whether the items tab is selected
    var wishlistCellId: String {
        switch tabSelected {
        case .collections:
            return "collectionItemCell"
        case .items:
            return "itemCell"
        case .outfits:
            return "outfitCell"
        }
    }
    
    // MARK: - Stored Properties
    /// Number of cells to show per row: 2 for vertical and 4 for horizontal orientations
    var cellsPerRow = 2
    
    /// True when items tab is selected, false when outfits tab is selected
    var tabSelected: TabSelected = .items {
        didSet {
            Wishlist.itemsTabSuggested = tabSelected == .items
            updateUI()
        }
    }
    
    // MARK: - Custom Methods
    /// Select the suggested tab
    func selectSuggestedTab() {
        switch Wishlist.itemsTabSuggested {
        case true:
            tabSelected = .items
        case false:
            tabSelected = .outfits
        }
    }
    
    /// Update items or outfits displayed depending on items selected state
    func updateUI(isHorizontal: Bool? = nil) {
        // Set the number of cells per row
        let size = view.bounds.size
        let isHorizontal = isHorizontal ?? (size.height < size.width)
        cellsPerRow = isHorizontal ? 4 : 2
        
        // Update buttons visibility
        collectionsButton.titleLabel?.alpha = tabSelected == .collections ? 1 : 0.5
        collectionsUnderline.isHidden = tabSelected != .collections
        itemsButton.titleLabel?.alpha = tabSelected == .items ? 1 : 0.5
        itemsUnderline.isHidden = tabSelected != .items
        outfitsButton.titleLabel?.alpha = tabSelected == .outfits ? 1 : 0.5
        outfitsUnderline.isHidden = tabSelected != .outfits
        
        // Reload collection view
        wishlistCollectionView.reloadData()
    }
    
    // MARK: - Inherited Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case ItemViewController.segueIdentifier:
            guard let destination = segue.destination as? ItemViewController else { return }
            guard let selectedIndexPath = wishlistCollectionView.indexPathsForSelectedItems?.first else { return }
            guard let itemCell = wishlistCollectionView.cellForItem(at: selectedIndexPath) as? ItemCell else { return }
            guard let itemIndex = wishlist[selectedIndexPath.row].item?.itemIndex else { return }
            destination.image = itemCell.pictureImageView.image
            destination.itemIndex = itemIndex
        default:
            debug("WARNING: Unknown segue identifier", segue.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Set data source and delegate for wish list
        wishlistCollectionView.dataSource = self
        wishlistCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectSuggestedTab()
        updateUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI(isHorizontal: size.height < size.width)
    }
    
    // MARK: - Actions
    @IBAction func collectionsButtonTapped(_ sender: UIButton) {
        tabSelected = .collections
    }
    
    @IBAction func itemsButtonTapped(_ sender: UIButton) {
        tabSelected = .items
    }
    
    @IBAction func outfitsButtonTapped(_ sender: UIButton) {
        tabSelected = .outfits
    }
}
