//
//  BulletinDataScource.swift
//  IslamicLandmarksAR
//
//  Created by Hamza Lakhani on 2018-11-30.
//  Copyright © 2018 DateSeed Technologies. All rights reserved.
//
import UIKit
import BLTNBoard
import SafariServices
import Foundation

enum BulletinDataSource {
    
    // MARK: - Pages
    
    /**
     * Create the introduction page.
     *
     * This creates a `FeedbackPageBLTNItem` with: a title, an image, a description text and
     * and action button.
     *
     * The action button presents the next item (the textfield page).
     */
    
    static func makeIntroPage() -> IntroPageItem {
        
        let page = IntroPageItem(title: "Tutorial")
        page.image = UIImage(named: "mosque")
        
        page.descriptionText = "How to use Landmarks AR."
        page.actionButtonTitle = "Lets Go!!!"
        
        page.isDismissable = true
        page.shouldStartWithActivityIndicator = true
        
        page.presentationHandler = { item in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                item.manager?.hideActivityIndicator()
            }
            
        }
        page.actionHandler = { item in
            item.manager?.displayNextItem()
        }

//
//        page.alternativeHandler = { item in
//            let privacyPolicyVC = SFSafariViewController(url: URL(string: "https://example.com")!)
//            item.manager?.present(privacyPolicyVC, animated: true)
//        }
//
        page.next = selectLandmarkpage()
        
        return page
        
}
    
    static func selectLandmarkpage() -> BLTNPageItem{
        
        
        let page = BLTNPageItem(title: "Select a landmark")
        
        page.descriptionText = "choose from the list of landmarks!"
        page.actionButtonTitle = "Next"
        page.image = UIImage(named: "mecca1")

        page.isDismissable = true
        page.shouldStartWithActivityIndicator = true
        
        page.presentationHandler = { item in
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                item.manager?.hideActivityIndicator()
            }
            
        }
        page.actionHandler = { item in
            item.manager?.displayNextItem()
        }
        
        page.next = detectPlanepage()

        return page

    }
    
    static func detectPlanepage() -> BLTNPageItem{
        
        
        let page = BLTNPageItem(title: "move phone around to detect plane until focus square appears")
        
        page.descriptionText = "flat and well lit areas are detected faster.!"
        page.actionButtonTitle = "Next"
        page.image = UIImage(named: "close1")
        page.appearance.imageViewTintColor = .black

        page.isDismissable = true
        page.shouldStartWithActivityIndicator = true
        
        page.presentationHandler = { item in
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                item.manager?.hideActivityIndicator()
            }
            
        }
        page.actionHandler = { item in
            item.manager?.displayNextItem()
        }
        
        page.next = tappage()
        
        
        return page
        
    }
    
    static func tappage() -> BLTNPageItem{
        
        
        let page = BLTNPageItem(title: "tap on the focus square to place landmark")
        
        page.descriptionText = "pinch to resize or rotate and move landmark around and see from different angles "
        page.actionButtonTitle = "Next"
        page.image = UIImage(named: "interactive-1")
        
        page.isDismissable = true
        page.shouldStartWithActivityIndicator = true
        
        page.presentationHandler = { item in
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                item.manager?.hideActivityIndicator()
            }
            
        }
        
        page.actionHandler = { item in
            item.manager?.displayNextItem()
        }
        
        page.next = makeCompletionPage()
        
        return page
        
    }
  
    static func makeCompletionPage() -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "Tutorial Completed")
        page.image = UIImage(named: "istanbul1")
        page.imageAccessibilityLabel = "Checkmark"
        page.appearance.actionButtonColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.appearance.imageViewTintColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.appearance.actionButtonTitleColor = .white
        
        page.descriptionText = "Landmarks is ready for you to use. Happy browsing!"
        page.actionButtonTitle = "Get started"
        page.alternativeButtonTitle = "Replay"
        
        page.isDismissable = true
        
        page.dismissalHandler = {item in
            NotificationCenter.default.post(name: .SetupDidComplete, object: item)
        }
        
        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        page.alternativeHandler = { item in
            item.manager?.popToRootItem()
        }
        
        return page
        
    }
    
}
// MARK: - Appearance



// MARK: - Notifications

extension Notification.Name {
    
    /**
     * The favorite tab index did change.
     *
     * The user info dictionary contains the following values:
     *
     * - `"Index"` = an integer with the new favorite tab index.
     */
    
    static let FavoriteTabIndexDidChange = Notification.Name("PetBoardFavoriteTabIndexDidChangeNotification")
    
    /**
     * The setup did complete.
     *
     * The user info dictionary is empty.
     */
    
    static let SetupDidComplete = Notification.Name("PetBoardSetupDidCompleteNotification")
    
}
