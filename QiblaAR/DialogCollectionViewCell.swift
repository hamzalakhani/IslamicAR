//
//  DialogCollectionViewCell.swift
//  QiblaAR
//
//  Created by Hamza Lakhani on 2018-11-23.
//  Copyright © 2018 DateSeed Technologies. All rights reserved.
//

import UIKit
import  AudioToolbox
import SceneKit

class DialogCollectionViewCell: UICollectionViewCell {
 
    
    var delegate: DialogCollectionViewCellDelegate?
    var index = 0
    
    @IBOutlet weak var screenImageButton: UIButton!
    
    @IBOutlet weak var screenLabel: UILabel!
    
    
    @IBOutlet weak var nodeView: SCNView!
    
    
    @IBAction func screenImageButtonTapped(_ sender: UIButton) {
        let pop = SystemSoundID(1520)
        AudioServicesPlaySystemSound(pop)
//        let dVC = DialogViewController()
//        dVC.performSegue(withIdentifier: "ToAR", sender: nil)
        delegate?.screenImageButtonTapped(index: index)
   }
    
    
    
}


protocol DialogCollectionViewCellDelegate {

    func screenImageButtonTapped(index: Int)

}
