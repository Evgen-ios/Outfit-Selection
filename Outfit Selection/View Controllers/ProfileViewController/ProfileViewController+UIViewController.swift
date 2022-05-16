//
//  ProfileViewController+UIViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 10.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIViewController
extension ProfileViewController {
    // MARK: - Inhertited Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Find and configure brands view controller
        brandsViewController = navigationController?.findViewController(ofType: BrandsViewController.self)
        
        // Configure user profile section
        userCredentials.updateValue(User.current.displayName ?? "", forKey: "Name:"~)
        userCredentials.updateValue(User.current.email ?? "", forKey: "Email:"~)
        userCredentials.updateValue(User.current.phone ?? "", forKey: "Phone:"~)
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
    
        // Setup profile collection view
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        profileCollectionView.register(BrandCollectionViewCell.nib, forCellWithReuseIdentifier: BrandCollectionViewCell.reuseId)
        profileCollectionView.register(GenderCollectionViewCell.nib, forCellWithReuseIdentifier: GenderCollectionViewCell.reuseId)
        profileCollectionView.register(AccountCollectionViewCell.nib, forCellWithReuseIdentifier: AccountCollectionViewCell.reuseId)
        profileCollectionView.register(OccasionCollectionViewCell.nib, forCellWithReuseIdentifier: OccasionCollectionViewCell.reuseId)
        profileCollectionView.register(FeedsCollectionViewCell.nib, forCellWithReuseIdentifier: FeedsCollectionViewCell.reuseId)
        profileCollectionView.register(ProfileSectionHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: ProfileSectionHeaderView.reuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure shown brands and gender match current brands and gender
        (tabBarController as? TabBarController)?.selectedBrands = BrandManager.shared.selectedBrands
        shownGender = Gender.current
        
        // Reload brand and gender data
        profileCollectionView.reloadData()
        
        // Show Tabbar
        showTabBar()
        
        // Reload Data
        brandsViewController?.reloadData()
        
        // Configure version label with version and build
        configureVersionLabel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileCollectionView.reloadData()
    }
}
