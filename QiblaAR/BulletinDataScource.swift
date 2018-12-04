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
        page.next = detectPlanepage()
        
        return page
        
}
    
    static func detectPlanepage() -> BLTNPageItem{
        
        
        let page = BLTNPageItem(title: "Plane Detection")
        
        page.descriptionText = "Move phone to detect a flat surface. Hint: good lighting helps!"
        page.actionButtonTitle = "Next"
        
        page.isDismissable = true
        page.shouldStartWithActivityIndicator = true
        
        page.presentationHandler = { item in
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                item.manager?.hideActivityIndicator()
            }
            
        }
        
        return page

    }
    
}
