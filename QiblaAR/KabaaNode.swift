//
//  KabaaNode.swift
//  QiblaAR
//
//  Created by Hamza Lakhani on 2018-11-20.
//  Copyright © 2018 DateSeed Technologies. All rights reserved.
//


    import UIKit
    import SceneKit
    import ARKit



    extension ViewController {
        
        fileprivate func getModel(named name: String) -> SCNNode? {
            let scene = SCNScene(named: "art.scnassets/\(name).scn")
            guard let model = scene?.rootNode.childNode(withName: "KabaaMain", recursively: false) else {return nil}
            model.name = name
            
            var scale: CGFloat
            
            switch name {
            case "kabaa":         scale = 0.0001
//            case "iPhone6s":        scale = 0.025
//            case "iPhone7":         scale = 0.0001
//            case "iPhone8":         scale = 0.000008
//            case "iPhone8Plus":     scale = 0.000008
//            case "iPad4":           scale = 0.00054
//            case "MacBookPro13":    scale = 0.0022
//            case "iMacPro":         scale = 0.0245
//            case "AppleWatch":      scale = 0.0000038
            default:                scale = 1
            }
            
            model.scale = SCNVector3(scale, scale, scale)
            return model
        }
        
        
        
        
        @IBAction func plusButtontapped(_ sender: UIButton)  {
            print("Add button tapped")
            
            guard focusSquare != nil else {return}
            
            let modelName = "kabaa"
            guard let model = getModel(named: modelName) else {
                print("Unable to load \(modelName) from file")
                return
                
            }
            
            
        
            
            let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
            guard let worldTransformColumn3 = hitTest.first?.worldTransform.columns.3 else {return}
            model.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
            
            sceneView.scene.rootNode.addChildNode(model)
            print("\(modelName) added successfully")
            
            modelsInTheScene.append(model)
            print("Currently have \(modelsInTheScene.count) model(s) in the scene")
        }
}
















//    override init() {
//        super.init()
//        guard let virtualObjectScene = SCNScene(named: "art.scnassets/kabaa.scn") else { return }
//        let wrapperNode = SCNNode()
//        for child in virtualObjectScene.rootNode.childNodes {
//            wrapperNode.addChildNode(child)
//
//        }
//        addChildNode(wrapperNode)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}
////    func loadModel() {
////    guard let virtualObjectScene = SCNScene(named: "art.scnassets/kabaa.scn") else { return }
////    let wrapperNode = SCNNode()
////    for child in virtualObjectScene.rootNode.childNodes {
////    wrapperNode.addChildNode(child)
////    }
//
////    addChildNode(wrapperNode)
////    }
////
////
////
////}
