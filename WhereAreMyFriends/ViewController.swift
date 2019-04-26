//
//  ViewController.swift
//  WhereAreMyFriends
//
//  Created by Welson Pan on 4/25/19.
//  Copyright © 2019 Welson Pan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import ModelIO
import SceneKit.ModelIO

class ViewController: UIViewController, ARSCNViewDelegate {

    fileprivate let myfriend = Friend(id: "FAKE_ID", firstName: "Welson", lastName: "Pan", longitude: -122.431297, latitude: 37.830506)
    fileprivate let myfriend1 = Friend(id: "FAKE_ID1", firstName: "Welson", lastName: "Pan", longitude: -122.431297, latitude: 37.730506)
    fileprivate let myfriend2 = Friend(id: "FAKE_ID2", firstName: "Welson", lastName: "Pan", longitude: -122.481297, latitude: 37.730506)
    fileprivate let myfriend3 = Friend(id: "FAKE_ID3", firstName: "Welson", lastName: "Pan", longitude: -122.331297, latitude: 37.730506)
    fileprivate let myfriend4 = Friend(id: "FAKE_ID4", firstName: "Welson", lastName: "Pan", longitude: -122.481297, latitude: 37.830506)
    fileprivate let myfriend5 = Friend(id: "FAKE_ID5", firstName: "Welson", lastName: "Pan", longitude: -122.331297, latitude: 37.830506)
    fileprivate let myfriend6 = Friend(id: "FAKE_ID6", firstName: "Welson", lastName: "Pan", longitude: -122.381297, latitude: 37.840506)
    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)
//    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Welson", lastName: "Pan", longitude: -122.401297, latitude: 37.800506)

    fileprivate let locationManager = CLLocationManager()

    var friendDetailView: FriendDetailView?

    var mostRecentUserLocation: CLLocation? = CLLocation(latitude: 37.780506, longitude: -122.431297)

    var friends: [Friend] = [] {
        didSet {
            guard let userLocation = mostRecentUserLocation else {
                return
            }

            for friend in friends {
                if let existingNode = friendNodes[friend.id] {
                    let move = SCNAction.move(to: friend.sceneKitCoordinate(relativeTo: userLocation), duration: TimeInterval(0.5))
                    existingNode.runAction(move)
                } else {
                    let newNode = newFriendNode()
                    friendNodes[friend.id] = newNode

                    newNode.position = friend.sceneKitCoordinate(relativeTo: userLocation)
                    newNode.rotation = friend.sceneKitRotation()
                    newNode.scale = SCNVector3(0.2, 0.2, 0.2)
                    sceneView.scene.rootNode.addChildNode(newNode)
                }
            }
        }
    }

    var friendNodes = [String: SCNNode]()

    // MARK: - Lifecycle

    override func loadView() {
        view = sceneView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSceneView()
        setupGestureRecognizer()
        // FIXME: This is hardcoding a friend
        friends = [myfriend, myfriend1, myfriend2, myfriend3, myfriend4, myfriend5, myfriend6, myfriend7]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration)
        setupLocationManager()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - Private

    private func setupSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true

//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//        sceneView.scene = scene
        sceneView.antialiasingMode = .multisampling2X
    }

    private func setupGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        sceneView.gestureRecognizers = [tapRecognizer]
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)

        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            guard let friendNode = hitResults.first?.node,
                let id = friendNodes.keys.first,
                let friend = friends.first(where: { $0.id == id }) else { return }
            addDetailView(for: friend, in: friendNode)
        }
    }

    func addDetailView(for friend: Friend, in node: SCNNode) {
        // TODO: implement me
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session did fail with error: \(error)")
    }

    func sessionWasInterrupted(_ session: ARSession) {
        print("Session has been interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session interruption ended")
    }

    private var sceneView: ARSCNView = {
        let sceneView = ARSCNView(frame: .zero)
        return sceneView
    }()

    // reorganize this file later

    lazy var friendModel: MDLObject = {
        let friendAssetUrl = Bundle.main.url(forResource: "777", withExtension: "obj")!
        return MDLAsset(url: friendAssetUrl).object(at: 0)
    }()

    private func newFriendNode() -> SCNNode {
        let friendNode = SCNNode(mdlObject: friendModel)

        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor(white:0.88, alpha:1.0)
        planeMaterial.reflective.contents = #imageLiteral(resourceName: "night")
        friendNode.geometry?.materials = [planeMaterial]

        let cylinder = SCNCylinder(radius: 30, height: 20)
        cylinder.firstMaterial?.diffuse.contents = UIColor.clear
        let largerNode = SCNNode(geometry: cylinder)
        largerNode.addChildNode(friendNode)

        return largerNode
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mostRecentUserLocation = locations[0] as CLLocation
    }
}
