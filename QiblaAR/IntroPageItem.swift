//
//  IntroPageItem.swift
//  IslamicLandmarksAR
//
//  Created by Hamza Lakhani on 2018-11-30.
//  Copyright © 2018 DateSeed Technologies. All rights reserved.
//

import Foundation
import UIKit
import BLTNBoard

class IntroPageItem: BLTNPageItem {
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    override func actionButtonTapped(sender: UIButton) {
        
        // Play an haptic feedback
        
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()
        
        // Call super
        
        super.actionButtonTapped(sender: sender)
        
}
}
