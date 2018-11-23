//
//  ViewController.swift
//  QiblaAR
//
//  Created by Hamza Lakhani on 2018-11-20.
//  Copyright © 2018 DateSeed Technologies. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    
    var kabaaMNode = KabaaNode()
    
    @IBOutlet var sceneView: ARSCNView!
    

    @IBAction func placeScreenTapped(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func plusButtontapped(_ sender: UIButton) {
        
        let scalePlus = SCNAction.scale(by: 2, duration: 2)
        kabaaMNode.runAction(scalePlus)
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        let scaleMinus = SCNAction.scale(by: 0.5, duration: 2)
        kabaaMNode.runAction(scaleMinus)
    }
    
    
    
    var planeGeometry:SCNPlane!
    let planeIdentifiers = [UUID]()
    var anchors = [ARAnchor]()
    var sceneLight:SCNLight!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/kabaa.scn")!
        
        sceneView.autoenablesDefaultLighting = false
    
        
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        let lightNode = SCNNode()
        lightNode.light = sceneLight
        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
        
        sceneView.scene.rootNode.addChildNode(lightNode)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
//    setting up touch to locate space for 3d object
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: sceneView)

       
        addNodeLocation(location: location!)
        }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node: SCNNode?
     
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node = SCNNode()
            planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            
            let planNode = SCNNode(geometry: planeGeometry)
            planNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            updateMaterial()
            
            node?.addChildNode(planNode)
            
            anchors.append(planeAnchor)
            
        }
        
        return node
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if anchors.contains(planeAnchor){
                if node.childNodes.count > 0{
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
                    
                    if let plane = planeNode.geometry as? SCNPlane{
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.height = CGFloat(planeAnchor.extent.z)
                        
                        updateMaterial()
                    }
                }
            }
            
        }
    }
    
    func updateMaterial()  {
        let material = self.planeGeometry.materials.first!
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
    }
    
    
    
    
    
    func addNodeLocation(location:CGPoint) {
        guard anchors.count > 0 else {print("anchors are not created yet"); return}
        
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if hitResults.count > 0 {
            let result = hitResults.first!
            let newLocation = SCNVector3(x: result.worldTransform.columns.3.x, y: result.worldTransform.columns.3.y , z: result.worldTransform.columns.3.z)
            
            let kabaaNode = KabaaNode()
            kabaaMNode = kabaaNode
            kabaaNode.position = newLocation
            sceneView.scene.rootNode.addChildNode(kabaaNode)
            
        }
    }
    
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
