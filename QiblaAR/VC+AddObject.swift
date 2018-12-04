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
    import AudioToolbox



    extension ViewController {
        
//            
        
        @objc func tappedLocation(_ gesture: UITapGestureRecognizer){
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
            
            plusButton.isHidden = false
            
            
        
            
//            sender.isHidden = true
            
            
        }
        
        
        @IBAction func plusButtontapped(_ sender: UIButton)  {
            
            
            
//            UIGraphicsBeginImageContext(view.frame.size)
//            view.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
            
            let image = sceneView.snapshot()
            AudioServicesPlaySystemSound(1108)
            flashScreen()
            //Save it to the camera roll
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            UIGraphicsEndImageContext()

        }
        
        
        
        
        private func flashScreen() {
            let flash = CALayer()
            flash.frame = view.bounds
            flash.backgroundColor = UIColor.white.cgColor
            view.layer.addSublayer(flash)
            flash.opacity = 0
            
            let anim = CABasicAnimation(keyPath: "opacity")
            anim.fromValue = 0
            anim.toValue = 1
            anim.duration = 0.1
            anim.autoreverses = true
            anim.isRemovedOnCompletion = true
            
            flash.add(anim, forKey: "flashAnimation")
            
        }
}






