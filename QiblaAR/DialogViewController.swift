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



class DialogViewController: UIViewController {
    
    
    let screens = ["mecca", "dome"]
    let titles = ["Holy Kabaa","Al-Aqsa"]
    
    let nodeArray  = [KabahNode(), AqsaNode()]

    let nodeArrayImages  = [KabahNode(), AqsaNode()]

    
    //let names
    var delegate: DialogViewControllerDelegate?
    
    @IBOutlet weak var screenCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        
        screenCollectionView.delegate = self
        screenCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    


}



extension DialogViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenCell", for: indexPath) as! DialogCollectionViewCell
        cell.screenImageButton.setImage(UIImage(named: screens[indexPath.row]), for: .normal)
        cell.screenLabel.text = titles[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        
        //scene view to show model in selection
        
//        let scene = SCNScene()
//        cell.nodeView.scene = scene
//        cell.nodeView.scene?.rootNode.addChildNode(nodeArrayImages[indexPath.row])
        
        return cell
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
