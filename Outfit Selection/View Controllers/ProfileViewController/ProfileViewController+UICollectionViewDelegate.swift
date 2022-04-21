//
//  ProfileViewController+UICollectionViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit
import CoreAudio

// MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    /// Perform an action when a user taps an item in the profile collection view
    /// - Parameters:
    ///   - collectionView: the profile collection view
    ///   - indexPath: item index path the user has tapped on
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            
            //debug(indexPath.row, User.current.isLoggedIn, User.current.sequenceCredentials[indexPath.row])
            // logout current user
            if User.current.isLoggedIn != nil {
                if User.current.sequenceCredentials[indexPath.row] == "Log out"~ {
                    // Logout into current account
                    logout()
                }
                
            } else {
                // Instantiate the tab bar controller
                let mainStoryboard = UIStoryboard(name: "Signup", bundle: nil)
                let signupViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignupViewController")
                self.navigationController?.showDetailViewController(signupViewController, sender: nil)
            }
            
        case 1:
            // Section 0 is gender — check if the user wants to change it
            let newGender = Gender.allCases[indexPath.row]
            guard let currentGender = Gender.current, newGender != shownGender else { return }
            if currentGender != newGender {
                present(Alert.genderChange(to: newGender, sender: self), animated: true)
            } else {
                if newGender != shownGender {
                    shownGender = newGender
                    collectionView.reloadSections([0])
                }
            }
            
        case 2:
            // Select occasion and go to OccasionsViewController for edit list occasions
            let mainStoryboard = UIStoryboard(name: "Welcome", bundle: nil)
            let occasionsViewController = mainStoryboard.instantiateViewController(withIdentifier: "OccasionsViewController")
            // Set isEditing true
            occasionsViewController.setEditing(true, animated: true)
            // Load OccasionsViewController
            self.navigationController?.show(occasionsViewController, sender: nil)
            
        case 3:
            // Select brnd and go to BrandsViewController for edit list barnds
            guard let brandsViewController = brandsViewController else { return }
            // Set isEditing true
            brandsViewController.setEditing(true, animated: true)
            // Load barndsViewController
            self.navigationController?.show(brandsViewController, sender: nil)
            
        default:
            debug("WARNING: Unknown section \(indexPath.section), row \(indexPath.row)")
        }
    }

}
