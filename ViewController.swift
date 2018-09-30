//
//  ViewController.swift
//  hackyhackhack
//
//  Created by Chen Caijie on 29/9/18.
//  Copyright © 2018 Chen Caijie. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var videoType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
      
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
      
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
      guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
      
      let width = CGFloat(planeAnchor.extent.x)
      if (width < 0.5) {
        return
      }
      //let height = CGFloat(planeAnchor.extent.z)
      let plane = SCNPlane(width: width, height: width/16*9)
      
      let videoNode = videoType%2 == 0 ? SKVideoNode(fileNamed: "ad.mp4") : SKVideoNode(fileNamed: "ad2.mp4")
      videoType += 1
      videoNode.play()
      let skScene = SKScene(size: CGSize(width: 640, height: 480))
      skScene.addChild(videoNode)
      videoNode.position = CGPoint(x: skScene.size.width/2, y: skScene.size.height/2)
      videoNode.size = skScene.size
      
      plane.materials.first?.diffuse.contents = skScene
      plane.materials.first?.isDoubleSided = true
      
      let planeNode = SCNNode(geometry: plane)
      
      let x = CGFloat(planeAnchor.center.x)
      let y = CGFloat(planeAnchor.center.y)
      let z = CGFloat(planeAnchor.center.z)
      planeNode.position = SCNVector3(x,y,z)
      planeNode.eulerAngles.x = .pi / 2
      
      let parentNode = node.parent
      let otherNodes = parentNode?.childNodes.filter { !$0.isEqual(node) }
      otherNodes?.forEach { node in node.removeFromParentNode()}
      node.addChildNode(planeNode)
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
