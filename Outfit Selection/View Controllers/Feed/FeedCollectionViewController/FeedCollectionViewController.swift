//
//  FeedCollectionViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import IBPCollectionViewCompositionalLayout

/// Controller managing feed collection at feed tab
class FeedCollectionViewController: LoggingViewController {
    // MARK: - Outlets
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    // MARK: - Stored Properties
    /// The collection of branded images
    let brandedImages = Brands.prioritizeSelected
    
    /// Items for each of the kinds
    var items: [FeedKind: Items] = [:]
    
    /// The maximum number of items in each section
    let maxItemsInSection = Globals.Feed.maxItemsInSection
    
    /// Parent navigation controller if called from another view controller
    var parentNavigationController: UINavigationController?
    
    /// Saved brand cell margins and paddings
    var savedBrandCellConstants: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    /// Types (kinds) for each of the section
    var sections: [FeedKind] = [] {
        didSet {
            updateItems(sections: sections)
        }
    }
    
    /// The set of brand tags previously selected by the user
    var selectedBrands: Set<String> = []
    
    ///Non empty sections after filter
    var nonEmptySections: [FeedKind] = [] {
        didSet {
            debug("INFO: New count sections", nonEmptySections.count)
            if nonEmptySections == [FeedKind.brands, FeedKind.emptyBrands] {
                self.feedCollectionView.reloadData()
            }
        }
    }

    // MARK: - Computed Properties
    /// True if brand selection has changed
    var haveBrandsChanged: Bool {
        BrandManager.shared.selectedBrands != selectedBrands
    }
    
    // MARK: - Custom Methods
    /// Append items to the section of given type (kind)
    /// - Parameters:
    ///   - items: items to append to the section
    ///   - section: the section type (kind) to append the items to
    func addSection(items: Items, to section: FeedKind) {
        if items.isEmpty {
            debug("INFO: No items in section", section.title )
            self.items[section] = nil
            
        } else {
            sections.append(section)
            self.items[section] = items
        }
    }
    
    /// Gets items depending on feed type (kind)
    /// - Parameters:
    ///   - kind: feed type (kind)
    ///   - ignoreBrands: should we ignore brands (false by default)
    ///   - completion: closure without parameters
    func getItems(for kind: FeedKind, ignoreBrands: Bool = false,  completion: @escaping () -> Void) {
        
        // Stop loading if section with brands
        guard kind != .brands || kind != .emptyBrands  else {
            // Reload data
            completion()
            return
        }
        
        // All sections will need to be filtered by brands
        let brandManager = BrandManager.shared
        let brandNames = brandManager.selectedBrandNames
        
        // Categories should be limited for occasions
        let subcategoryIDs: [Int] = {
            if case let .occasions(id) = kind {
                return Occasions.byID[id]?.flatSubcategoryIDs.compactMap { $0 } ?? []
            } else {
                return []
            }
        }()
        
        // If feed type is sale get items with old prices set
        let sale = kind == .sale
        NetworkManager.shared.getItems(
            subcategoryIDs: subcategoryIDs,
            filteredBy: ignoreBrands ? [] : brandNames,
            limited: self.maxItemsInSection * 2,
            sale: sale
        ) { [weak self] items in
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                completion()
                return
            }
            
            // Check items
            guard var items = items?.shuffled(), !items.isEmpty else {
                completion()
                return
            }
            
            // Put the last selected brand name first
            if let lastSelectedBrandName = brandManager.lastSelected?.brandName {
                let lastSelectedBrandNames = [lastSelectedBrandName]
                items.sort { $0.branded(lastSelectedBrandNames) || !$1.branded(lastSelectedBrandNames)}
            }
            
            DispatchQueue.main.async {
                // Set items into current kind
                self.items[kind] = items
                completion()
            }
        }
    }
    
    /// Set section into UICollectionView
    /// - Parameters:
    ///   - emptySection: marker for set only brands and an enpty sectiion
    func setSection(with emptySection: Bool = false) {
        
        // Check selected count of brands
        if Brands.selected.count > 0 && !emptySection {
            // Initial sections for feed collection view
            nonEmptySections = [
                FeedKind.brands,
                FeedKind.newItems,
                FeedKind.sale,
            ] + Occasions.selectedIDsUniqueTitle.map { .occasions($0) }
            sections = nonEmptySections
            
        } else {
            // Initial sections for feed collection view
            nonEmptySections = [FeedKind.brands, FeedKind.emptyBrands]
            sections = nonEmptySections
        }
    }
    
    /// Register cells, set data source and delegate for a given collection view
    /// - Parameters:
    ///   - collectionView: collection view to setup
    ///   - withBrandsOnTop: if true add brands row on top of collection view
    func setup(_ collectionView: UICollectionView, withBrandsOnTop: Bool) {
        // Register feed cell with feed table view
        BrandCollectionViewCell.register(with: collectionView)
        FeedItemCollectionCell.register(with: collectionView)
        FeedSectionHeaderView.register(with: collectionView)
        
        // Set self as feed table view data source and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Generate collection view layout
        collectionView.setCollectionViewLayout(configureLayout(withBrandsOnTop: withBrandsOnTop), animated: false)
    }
    
    /// Download items for section
    /// - Parameters:
    ///   - sections: sections for set and download items
    func updateItems(sections: [FeedKind]) {
        if !Brands.selected.isEmpty {
            
            // If current sections only with brands and emptySection
            guard sections != [FeedKind.brands, FeedKind.emptyBrands] else {
                self.feedCollectionView.reloadData()
                return
            }
            
            // Dispatch group to wait for all requests to finish
            let group = DispatchGroup()
            for section in sections {
                group.enter()
                
                // Get items for section
                self.getItems(for: section, completion: {
                    
                    debug("INFO: Get items", section.title, self.items[section]?.count)
                    
                    if self.items[section] == nil || section == .brands  {
                        group.leave()
                        
                    } else {
                        DispatchQueue.main.async { [self] in
                            
                            // Replace element current section
                            nonEmptySections.replaceElement(section, withElement: section)
                            
                            // Get index with updated element
                            let updatedSections = self.nonEmptySections.enumerated().compactMap { index, kind in
                                section == kind ? index : nil
                            }
                            // Reload sections where was updated items
                            feedCollectionView?.reloadSections(IndexSet(updatedSections))
                            group.leave()
                        }
                    }
                })
            }
            
            // Notification from DispatchQueue group when all section got answer
            group.notify(queue: .main) { [self] in
                debug("INFO: Get items FINISH")
                
                //Get sections with empty items and ignore brands
                let emptySection = sections.filter { items[$0] == nil && $0 != .brands }
                
                // Remove all emptySection
                nonEmptySections.removeAll(where: { emptySection.contains($0) } )
                
                // Show choose brands section, if after clear you'll get only brands section
                if nonEmptySections.count == 1 {
                    self.nonEmptySections = ([FeedKind.brands, FeedKind.emptyBrands])
                }
                
                // Reload data into UICollectionView
                feedCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Set navigation item title
        title = "Feed"~
        
        // Set selected brands
        selectedBrands = BrandManager.shared.selectedBrands
        
        // Set section into UICollectionView
        setSection()
        
        // Set self as data source and register collection view cells and header
        setup(feedCollectionView, withBrandsOnTop: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if haveBrandsChanged {
            debug("INFO: Brands will changed")
            
            // Clear initial items
            items = [:]
            
            // Set selected brands
            selectedBrands = BrandManager.shared.selectedBrands
            
            // Make feed item cells reload
            setSection()
            
            // Reload data
            self.feedCollectionView.reloadData()
        }
        
        // Set margins and paddings for brand cell
        savedBrandCellConstants = (
            BrandCollectionViewCell.horizontalMargin,
            BrandCollectionViewCell.horizontalPadding,
            BrandCollectionViewCell.verticalMargin,
            BrandCollectionViewCell.verticalPadding
        )
        
        BrandCollectionViewCell.horizontalMargin = 0
        BrandCollectionViewCell.horizontalPadding = 20
        BrandCollectionViewCell.verticalMargin = 0
        BrandCollectionViewCell.verticalPadding = 20
        
        //  Reload section with brands
        feedCollectionView.reloadSections(IndexSet([0]))
        
        // Make sure like buttons are updated when we come back from see all screen
        feedCollectionView.visibleCells.forEach {
            ($0 as? FeedItemCollectionCell)?.configureLikeButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restore margins and paddings for brand cell
        (
            BrandCollectionViewCell.horizontalMargin,
            BrandCollectionViewCell.horizontalPadding,
            BrandCollectionViewCell.verticalMargin,
            BrandCollectionViewCell.verticalPadding
        ) = savedBrandCellConstants
    }
}
