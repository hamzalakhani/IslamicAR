//
//  DialogCollectionViewCell.swift
//  QiblaAR
//
//  Created by Hamza Lakhani on 2018-11-23.
//  Copyright © 2018 DateSeed Technologies. All rights reserved.
//

import UIKit

class DialogCollectionViewCell: UICollectionViewCell {
 
    
    var delegate: DialogCollectionViewCellDelegate?
    var index = 0
    
    @IBOutlet weak var screenImageButton: UIButton!
    
    @IBOutlet weak var screenLabel: UILabel!
    
    
    @IBAction func screenImageButtonTapped(_ sender: UIButton) {
        delegate?.screenImageButtonTapped(index: index)

    }
    
    
    
}


protocol DialogCollectionViewCellDelegate {

    func screenImageButtonTapped(index: Int)

}
