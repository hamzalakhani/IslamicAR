//
//  KabaaNode.swift
//  QiblaAR
//
//  Created by Hamza Lakhani on 2018-11-20.
//  Copyright © 2018 DateSeed Technologies. All rights reserved.
//

import SceneKit

class KabaaNode: SCNNode {
    override init() {
        super.init()
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/kabaa.scn") else { return }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
            
        }
        addChildNode(wrapperNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
//    func loadModel() {
//    guard let virtualObjectScene = SCNScene(named: "art.scnassets/kabaa.scn") else { return }
//    let wrapperNode = SCNNode()
//    for child in virtualObjectScene.rootNode.childNodes {
//    wrapperNode.addChildNode(child)
//    }

//    addChildNode(wrapperNode)
//    }
//
//
//
//}
