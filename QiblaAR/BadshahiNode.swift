//
//  BadshahiNode.swift
//  IslamicLandmarksAR
//
//  Created by Hamza Lakhani on 2018-12-04.
//  Copyright © 2018 DateSeed Technologies. All rights reserved.
//

import Foundation

import UIKit
import ARKit
import SceneKit

class BadhshahiNode: SCNNode {
    
    override init() {
        
        super.init()
        
        
        guard   let scene = SCNScene(named: "art.scnassets/BlueMosque.scn")else { return }
        
        let model = SCNNode()
        //        for child in virtualObjectScene.rootNode.childNodes {
        //            wrapperNode.addChildNode(child)
        for child in scene.rootNode.childNodes{
            model.addChildNode(child)
        }
        //                model.name = name
        
        //                var scale: CGFloat
        //                switch name {
        //                case "kabaa":         scale = 0.0001
        //                default:                scale = 1
        //                }
        model.scale = SCNVector3(0.01, 0.01, 0.01)
        addChildNode(model)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
