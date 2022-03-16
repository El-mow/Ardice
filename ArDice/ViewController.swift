//
//  ViewController.swift
//  ArDice
//
//  Created by mobin on 2/11/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var dices = [SCNNode]()
    override func viewDidLoad() {
        super.viewDidLoad()

        //
//        let moon = SCNSphere(radius: 0.2)
//        let material = SCNMaterial()
//        let image = SCNMaterial()
//        image.diffuse.contents = UIImage(named: "art.scnassets/dice.scn")
//
//
//        moon.materials = [image ]
//        let moonNode = SCNNode()
//        moonNode.position = SCNVector3(x:0,y: 0.5, z: -2)
//        moonNode
//            .geometry = moon
//        sceneView.scene.rootNode.addChildNode(moonNode)
//        sceneView.automaticallyUpdatesLighting
//
        
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
      

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        print(ARWorldTrackingConfiguration.isSupported)
        print(ARConfiguration.isSupported)
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touches = touches.first{
            let touchLocation = touches.location(in: sceneView)
            let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if let hitresult = result.first {
                 addDice(atlocation: hitresult)
//                let diceScene = SCNScene(named: "art.scnassets/dice.scn")
//                if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true) {
//                    diceNode.position = SCNVector3(hitresult.worldTransform.columns.3.x, hitresult.worldTransform.columns.3.y + diceNode.boundingSphere.radius, hitresult.worldTransform.columns.3.z
//                    )
//                    dices.append(diceNode)
//                    sceneView.scene.rootNode.addChildNode(diceNode)
//                    let randomx = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
//                    let randomz = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
//                    diceNode.runAction(SCNAction.rotateBy(
//                        x: CGFloat(randomx * 5),
//                        y: 0,
//                        z: CGFloat(randomz * 5),
//                        duration: 2))
//                }
                
            }else {
                print("plain is touched")
            }
        }
    }
    func rolAllDice(){
        if !dices.isEmpty {
            for dice in dices {
                rollDice(outDice: dice)
            }
        }
    }
    
    func addDice(atlocation location: ARHitTestResult){
        let diceScene = SCNScene(named: "art.scnassets/dice.scn")
        if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true) {
             diceNode.position = SCNVector3(
                location.worldTransform.columns.3.x, location.worldTransform.columns.3.y + dicedScene.boundingSphere.radius,
                location.worldTransform.columns.3.z
            )
            dices.append(diceNode)
            sceneView.scene.rootNode.addChildNode(diceNode)
            let randomx = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
            let randomz = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
            diceNode.runAction(SCNAction.rotateBy(
                x: CGFloat(randomx * 5),
                y: 0,
                z: CGFloat(randomz * 5),
                duration: 2))
        }
    }

    //MARK: - DelegateMethod
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
       
       guard let planeAnchor = anchor as? ARPlaneAnchor else {
           return
       }
       
         createPlane(withPlaneAnchor: planeAnchor)
    }
    
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
        
        if !dices.isEmpty {
            for dice in dices {
                dice.removeFromParentNode()
            }
            
        }
    }
    
    @IBAction func rollingAllDiecs(_ sender: UIBarButtonItem) {
        
        rolAllDice()
    }
    
    
    
    func rollDice (outDice dice:SCNNode){
        let randomx = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randomz = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        dice.runAction(SCNAction.rotateBy(
            x: CGFloat(randomx * 5),
            y: 0,
            z: CGFloat(randomz * 5),
            duration: 2))
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            rolAllDice()
        }
    }
    
   func createPlane( withPlaneAnchor planeAnchor : ARPlaneAnchor){
        

        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode()
      planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
      planeNode.transform = SCNMatrix4MakeRotation(Float.pi/2, 1, 0, 0)
      let gridMateril = SCNMaterial()
      gridMateril.diffuse.contents = UIImage(named:"art.scnassets/PUtin.jpeg")
      plane.materials = [gridMateril]
      planeNode.geometry = plane
      
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
