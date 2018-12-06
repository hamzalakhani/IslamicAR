//
//  DialogViewController.swift
//  QiblaAR
//
//  Created by Hamza Lakhani on 2018-11-23.
//  Copyright © 2018 DateSeed Technologies. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import BLTNBoard


class DialogViewController: UIViewController {
    
    
    let screens = ["mecca", "dome", "blue-mosque"]
    let titles = ["Holy Kabaa","Al-Aqsa", "Blue Mosque"]
    
    let nodeArray  = [KabahNode(), AqsaNode(),BadhshahiNode()]

    let nodeArrayImages  = [KabahNode(), AqsaNode(), BadhshahiNode()]

    //Bulletin Vars
    var currentBackground = (name: "Dimmed", style: BLTNBackgroundViewStyle.dimmed)
    private var shouldHideStatusBar: Bool = false
    
    lazy var bulletinManager: BLTNItemManager = {
        
        
        let introPage = BulletinDataSource.makeIntroPage()
        return BLTNItemManager(rootItem: introPage)
    }()
    //let names
    var delegate: DialogViewControllerDelegate?
    
    @IBOutlet weak var screenCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenCollectionView.delegate = self
        screenCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func showBulletin() {
        
        reloadManager()
        
        //        Uncomment to customize interface
        //        bulletinManager.cardCornerRadius = 22
        //        bulletinManager.edgeSpacing = .none
        //        bulletinManager.allowsSwipeInteraction = false
        //        bulletinManager.hidesHomeIndicator = true
        //        bulletinManager.backgroundColor = .blue
        
        bulletinManager.backgroundViewStyle = currentBackground.style
        bulletinManager.statusBarAppearance = shouldHideStatusBar ? .hidden : .automatic
        bulletinManager.showBulletin(above: self)
        
    }
    
    func reloadManager() {
        let introPage = BulletinDataSource.makeIntroPage()
        bulletinManager = BLTNItemManager(rootItem: introPage)
    }

}



extension DialogViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenCell", for: indexPath) as! DialogCollectionViewCell
        cell.screenImageButton.setImage(UIImage(named: screens[indexPath.row]), for: .normal)
        cell.screenLabel.text = titles[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        
//        let scene = SCNScene()
//        cell.nodeView.scene = scene
//        cell.nodeView.scene?.rootNode.addChildNode(nodeArrayImages[indexPath.row])
        
        return cell
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let coachMarksShown: Bool = UserDefaults.standard.bool(forKey: "MPCoachMarksShown")
        if coachMarksShown == false {
            // Don't show again
            UserDefaults.standard.set(true, forKey: "MPCoachMarksShown")
            UserDefaults.standard.synchronize()
            
            // Show coach marks
            showBulletin()

            // Or show coach marks after a second delay
            // [coachMarksView performSelector:@selector(start) withObject:nil afterDelay:1.0f];
        }

    }

}


extension DialogViewController: DialogCollectionViewCellDelegate{
    
    func screenImageButtonTapped(index: Int) {
        dismiss(animated: true, completion: nil)
//        delegate?.screenImageButtontapped(image: UIImage(named: images[index])!)
        
        delegate?.screenImageButtontapped(node: nodeArray[index])

}
}


protocol DialogViewControllerDelegate {
    func screenImageButtontapped(node: SCNNode)
}


//print("Add button tapped")
//
//guard focusSquare != nil else {return}
//
//let modelName = "kabaa"
//guard let model = getModel(named: modelName) else {
//    print("Unable to load \(modelName) from file")
//return
