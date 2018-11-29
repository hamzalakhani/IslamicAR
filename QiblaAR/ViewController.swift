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
import AudioToolbox
import Foundation
import QuartzCore



class ViewController: UIViewController  {
//, ARSCNViewDelegate
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var dalogButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    var focusSquare: FocusSquare?
    var screenCenter: CGPoint!
    var modelsInTheScene:Array<SCNNode> = []
    var selectedNode = SCNNode()
    //coachmarks
    //Store The Rotation Of The CurrentNode
    var currentAngleY: Float = 0.0
    
    //Not Really Necessary But Can Use If You Like
    var isRotating = false


    
    @IBOutlet var sceneView: ARSCNView!
//    let coachMarksController = CoachMarksController()
//    let pointOfInterest = UIView()


    @IBAction func placeScreenTapped(_ sender: UIButton) {
        let pop = SystemSoundID(1520)
        AudioServicesPlaySystemSound(pop)
        minusButton.isHidden = false
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
        let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        
        // Prepare shortly before playing
        lightImpactFeedbackGenerator.prepare()
        
        // Play the haptic signal
        lightImpactFeedbackGenerator.impactOccurred()
        
        
        modelsInTheScene.first?.removeFromParentNode()

        
            modelsInTheScene.removeFirst()

        
        plusButton.isHidden = true
        

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
            
            
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            
            // Prepare shortly before playing
            selectionFeedbackGenerator.prepare()
            
            // Play the haptic signal
            selectionFeedbackGenerator.selectionChanged()
            
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
        
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        
        // Prepare shortly before playing
        selectionFeedbackGenerator.prepare()
        
        // Play the haptic signal
        selectionFeedbackGenerator.selectionChanged()
        
        
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
        
        self.plusButton.isHidden = true
        self.minusButton.isHidden = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        //        let scene = SCNScene(named: "art.scnassets/kabaa.scn")!
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        
        screenCenter = view.center
        
        //coachmarks
        
            // Setup coach marks
            let coachmark1 = CGRect(x: (UIScreen.main.bounds.size.width - 125) / 2, y: 64, width: 125, height: 125)
            let coachmark2 = CGRect(x: (UIScreen.main.bounds.size.width - 300) / 2, y: coachmark1.origin.y + coachmark1.size.height, width: 300, height: 80)
            let coachmark3 = CGRect(x: 2, y: 20, width: 45, height: 45)
            
//            num MaskShape : Int {
//                case default
//                case shape_CIRCLE
//                case shape_SQUARE
//                }
//
//                enum LabelAligment : Int {
//                    case label_ALIGNMENT_CENTER
//                    case label_ALIGNMENT_LEFT
//                    case label_ALIGNMENT_RIGHT
//                }
//
//                enum LabelPosition : Int {
//                    case label_POSITION_BOTTOM
//                    case label_POSITION_LEFT
//                    case label_POSITION_TOP
//                    case label_POSITION_RIGHT
//                    case label_POSITION_RIGHT_BOTTOM
//                }
//
//                enum ContinueLocation : Int {
//                    case location_TOP
//                    case location_CENTER
//                    case location_BOTTOM
//                }
            // Setup coach marks
//        let coachMarks = [[setValue(coachmark1, forKey: "rect"),
//                              setValue("You can put marks over images", forKey: "caption"),
//                              setValue(MaskShape.SHAPE_CIRCLE, forKey: "shape"),
//                              setValue(LabelPosition.LABEL_POSITION_BOTTOM, forKey: "position"),
//                              setValue((Bool:true), forKey: "showArrow")],
//
//                              [setValue(coachmark2, forKey: "rect"),
//                            setValue("Also, we can show buttons", forKey: "caption")],
//
//
//                              [setValue(coachmark3, forKey: "rect"),
//                               setValue("And works with navigations buttons too", forKey: "caption"),
//                                setValue(MaskShape.SHAPE_SQUARE, forKey: "shape")
//            ]]
        
        let coachMarks: Array = [["react": coachmark1,
                                  "caption": "You can put marks over images",
                                  "shape": MaskShape.SHAPE_CIRCLE.rawValue,
                                  "position": LabelPosition.LABEL_POSITION_BOTTOM.rawValue,
                                  "showArrow": (Bool:true) ],
                                 ["react": coachmark2,
                                    "caption": "You can put marks over images",],
                                 ["react": coachmark3,
                                    "caption": "You can put marks over images",
                                    "shape": MaskShape.SHAPE_SQUARE.rawValue]]
        
            let coachMarksView = MPCoachMarks(frame: view.bounds, coachMarks: coachMarks)
            view.addSubview(coachMarksView!)
            coachMarksView!.start()

            
            
        
        
//        self.coachMarksController.dataSource = self
//        self.coachMarksController.start(on: self)

        
        
        
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
    
    //coachmarks methods
    
    
    
//    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
//        return 1
//    }
//    
//    
//    func coachMarksController(_ coachMarksController: CoachMarksController,
//                              coachMarkAt index: Int) -> CoachMark {
//        return coachMarksController.helper.makeCoachMark(for: pointOfInterest)
//    }
//    
//    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
//        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
//        
//        coachViews.bodyView.hintLabel.text = "Hello! I'm a Coach Mark!"
//        coachViews.bodyView.nextLabel.text = "Ok!"
//        
//        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
//    }

 
    
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
        
        let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(tappedLocation(_:)))
        self.view.addGestureRecognizer(tappedGesture)
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
        
        selectedNode = node
        
    }
}
    
    
    

