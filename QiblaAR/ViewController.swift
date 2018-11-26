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

class ViewController: UIViewController {
//, ARSCNViewDelegate
    
    var focusSquare: FocusSquare?
    var screenCenter: CGPoint!
    var modelsInTheScene:Array<SCNNode> = []
    
    
    //Store The Rotation Of The CurrentNode
    var currentAngleY: Float = 0.0
    
    //Not Really Necessary But Can Use If You Like
    var isRotating = false

    
    @IBOutlet var sceneView: ARSCNView!
    

    @IBAction func placeScreenTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "HomeToDialog", sender: nil)
        
    }
    
    
//    @IBAction func plusButtontapped(_ sender: UIButton) {
//        
//        let scalePlus = SCNAction.scale(by: 2, duration: 2)
//        
//        
//        let firstVisibleModel = modelsInTheScene.first
//        
//        firstVisibleModel?.runAction(scalePlus)
//
//
//
//        }
//
//    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        
        modelsInTheScene.first?.removeFromParentNode()

        modelsInTheScene.removeFirst()

    }
    
    
//    @objc func rotated(sender: UIRotationGestureRecognizer){
//        let firstVisibleModel = modelsInTheScene.first
//
//            if sender.state == .began || sender.state == .changed {
//                firstVisibleModel?.eulerAngles = SCNVector3(CGFloat((firstVisibleModel?.eulerAngles.x)!),sender.rotation,CGFloat((firstVisibleModel?.eulerAngles.z)!))
//            }
//        }
    @objc func moveNode(_ gesture: UIPanGestureRecognizer) {
        
        if !isRotating{
            
            //1. Get The Current Touch Point
            let currentTouchPoint = gesture.location(in: self.sceneView)
            
            //2. Get The Next Feature Point Etc
            guard let hitTest = self.sceneView.hitTest(currentTouchPoint, types: .existingPlane).first else { return }
            
            //3. Convert To World Coordinates
            let worldTransform = hitTest.worldTransform
            
            //4. Set The New Position
            let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
            
            //5. Apply To The Node
            
            let firstVisibleModel = modelsInTheScene.first

            firstVisibleModel!.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
            
        }
    }
    
    
    // Rotates An SCNNode Around It's YAxis
    ///
    /// - Parameter gesture: UIRotationGestureRecognizer
    @objc func rotateNode(_ gesture: UIRotationGestureRecognizer){
        
        let firstVisibleModel = modelsInTheScene.first

        
        //1. Get The Current Rotation From The Gesture
        let rotation = Float(gesture.rotation)
        
        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
        if gesture.state == .changed{
            isRotating = true
            firstVisibleModel!.eulerAngles.y = currentAngleY + rotation
        }
        
        //3. If The Gesture Has Ended Store The Last Angle Of The Cube
        if(gesture.state == .ended) {
            currentAngleY = firstVisibleModel!.eulerAngles.y
            isRotating = false
        }
    }

    
       @objc func pinched(sender: UIPinchGestureRecognizer) {
        
        
        let firstVisibleModel = modelsInTheScene.first
        
            let action = SCNAction.scale(by: sender.scale, duration: 0.1)
        firstVisibleModel!.runAction(action)
            sender.scale = 1
            

        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToDialog" {
            let toVC = segue.destination as! DialogViewController
            toVC.delegate = self
        }
    }
    
//    var planeGeometry:SCNPlane!
//    let planeIdentifiers = [UUID]()
//    var anchors = [ARAnchor]()
//    var sceneLight:SCNLight!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/kabaa.scn")!
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    
        
        screenCenter = view.center
        
//        let scene = SCNScene()
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
        
        
//        sceneLight = SCNLight()
//        sceneLight.type = .omni
//
//        let lightNode = SCNNode()
//        lightNode.light = sceneLight
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
//
//        sceneView.scene.rootNode.addChildNode(lightNode)
        
        addGestures()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
//        configuration.isLightEstimationEnabled = true
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let viewCenter = CGPoint(x: size.width / 2, y: size.height / 2)
        screenCenter = viewCenter
    }
    
    //gestures input
    func addGestures(){
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinched(sender:)))
        sceneView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveNode(_:)))
        self.view.addGestureRecognizer(panGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateNode(_:)))
        self.view.addGestureRecognizer(rotateGesture)
    }
    
    func updateFocusSquare() {
        guard let focusSquareLocal = focusSquare else {return}
        
        
        guard let pointOfView = sceneView.pointOfView else {return}
        
        let firstVisibleModel = modelsInTheScene.first { (node) -> Bool in
            return sceneView.isNode(node, insideFrustumOf: pointOfView)
        }
        let modelsAreVisible = firstVisibleModel != nil
        if modelsAreVisible != focusSquareLocal.isHidden {
            focusSquareLocal.setHidden(to: modelsAreVisible)
        }
        
        
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        if let hitTestResult = hitTest.first {
//            print("Focus square hits a plane")
            
            let canAddNewModel = hitTestResult.anchor is ARPlaneAnchor
            focusSquareLocal.isClosed = canAddNewModel
        } else {
//            print("Focus square does not hit a plane")
            
            focusSquareLocal.isClosed = false
        }
    }
    
    
    
    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        var node: SCNNode?
//
//        if let planeAnchor = anchor as? ARPlaneAnchor {
//            node = SCNNode()
//            planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//            planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
//
//            let planNode = SCNNode(geometry: planeGeometry)
//            planNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
//            planNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
//            updateMaterial()
//
//            node?.addChildNode(planNode)
//
//            anchors.append(planeAnchor)
//
//        }
//
//        return node
//    }

//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        if let planeAnchor = anchor as? ARPlaneAnchor {
//            if anchors.contains(planeAnchor){
//                if node.childNodes.count > 0{
//                    let planeNode = node.childNodes.first!
//                    planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
//                    
//                    if let plane = planeNode.geometry as? SCNPlane{
//                        plane.width = CGFloat(planeAnchor.extent.x)
//                        plane.height = CGFloat(planeAnchor.extent.z)
//                        
//                        updateMaterial()
//                    }
//                }
//            }
//            
//        }
//    }
//
//    func updateMaterial()  {
//        let material = self.planeGeometry.materials.first!
//        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
//    }
//
//
//
//
//
//    func addNodeLocation(location:CGPoint) {
//        guard anchors.count > 0 else {print("anchors are not created yet"); return}
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
//
//        }
//    }
//
    
   
    
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


extension ViewController: DialogViewControllerDelegate{
    func screenImageButtontapped(node: SCNNode) {
        
        
        guard focusSquare != nil else {return}
        
        
        
        
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        guard let worldTransformColumn3 = hitTest.first?.worldTransform.columns.3 else {return}
        node.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        sceneView.scene.rootNode.addChildNode(node)
        //            print("\(modelName) added successfully")
        
        modelsInTheScene.append(node)
        print("Currently have \(modelsInTheScene.count) model(s) in the scene")
    }
    }
    
    
    
    

