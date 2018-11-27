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
        
//            func getModel(named name: String) -> SCNNode? {
//            let scene = SCNScene(named: "art.scnassets/\(name).scn")
//            guard let model = scene?.rootNode.childNode(withName: "KabaaMain", recursively: false) else {return nil}
//            model.name = name
//
//            var scale: CGFloat
//
//            switch name {
//            case "kabaa":         scale = 0.0001
//            case "Quran":         scale = 0.025
////            case "iPhone7":         scale = 0.0001
////            case "iPhone8":         scale = 0.000008
////            case "iPhone8Plus":     scale = 0.000008
////            case "iPad4":           scale = 0.00054
////            case "MacBookPro13":    scale = 0.0022
////            case "iMacPro":         scale = 0.0245
////            case "AppleWatch":      scale = 0.0000038
//            default:                scale = 1
//            }
//
//            model.scale = SCNVector3(scale, scale, scale)
//            return model
//        }
        
        
        
        
        @IBAction func plusButtontapped(_ sender: UIButton)  {
            
            
            let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            
            lightImpactFeedbackGenerator.prepare()
            
            lightImpactFeedbackGenerator.impactOccurred()
            
            guard focusSquare != nil else {return}
            
            
        
            
            let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
            guard let worldTransformColumn3 = hitTest.first?.worldTransform.columns.3 else {return}
            selectedNode.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
            
            sceneView.scene.rootNode.addChildNode(selectedNode)
//            print("\(modelName) added successfully")
            
            modelsInTheScene.append(selectedNode)
            print("Currently have \(modelsInTheScene.count) model(s) in the scene")
            
            sender.isHidden = true

        }
}







//guard anchors.count > 0 else {print("anchors are not created yet"); return}
//
//        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
//        if hitResults.count > 0 {
//            let result = hitResults.first!
//            let newLocation = SCNVector3(x: result.worldTransform.columns.3.x, y: result.worldTransform.columns.3.y , z: result.worldTransform.columns.3.z)
//
//            let kabaaNode = KabaaNode()
//            kabaaMNode = kabaaNode
//            kabaaNode.position = newLocation
//            sceneView.scene.rootNode.addChildNode(kabaaNode)








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
