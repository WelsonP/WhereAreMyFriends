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
    fileprivate let myfriend1 = Friend(id: "FAKE_ID1", firstName: "Tony", lastName: "Pan", longitude: -122.431297, latitude: 37.770506)
    fileprivate let myfriend2 = Friend(id: "FAKE_ID2", firstName: "Brian", lastName: "Pan", longitude: -122.481297, latitude: 37.790506)
    fileprivate let myfriend3 = Friend(id: "FAKE_ID3", firstName: "Colm", lastName: "Pan", longitude: -122.331297, latitude: 37.737506)
    fileprivate let myfriend4 = Friend(id: "FAKE_ID4", firstName: "Arun", lastName: "Pan", longitude: -122.481297, latitude: 37.800506)
    fileprivate let myfriend5 = Friend(id: "FAKE_ID5", firstName: "Mike", lastName: "Pan", longitude: -122.331297, latitude: 37.880506)
    fileprivate let myfriend6 = Friend(id: "FAKE_ID6", firstName: "Jake", lastName: "Pan", longitude: -122.381297, latitude: 37.780506)
    fileprivate let myfriend7 = Friend(id: "FAKE_ID7", firstName: "Bipin", lastName: "Pan", longitude: -122.371297, latitude: 37.790506)
    fileprivate let myfriend8 = Friend(id: "FAKE_ID8", firstName: "Peter", lastName: "Pan", longitude: -122.371297, latitude: 37.770506)
    fileprivate let myfriend9 = Friend(id: "FAKE_ID9", firstName: "PJ", lastName: "Pan", longitude: -122.371297, latitude: 37.810506)
    fileprivate let myfriend10 = Friend(id: "FAKE_ID10", firstName: "Paul", lastName: "Pan", longitude: -122.411297, latitude: 37.810506)
    fileprivate let myfriend11 = Friend(id: "FAKE_ID11", firstName: "Sam", lastName: "Pan", longitude: -122.431297, latitude: 37.820506)
    fileprivate let myfriend12 = Friend(id: "FAKE_ID12", firstName: "King", lastName: "Pan", longitude: -122.441297, latitude: 37.830506)
    fileprivate let myfriend13 = Friend(id: "FAKE_ID13", firstName: "Queen", lastName: "Pan", longitude: -122.461297, latitude: 37.837506)
    fileprivate let myfriend14 = Friend(id: "FAKE_ID14", firstName: "Test", lastName: "Pan", longitude: -122.411297, latitude: 37.850506)
    fileprivate let myfriend15 = Friend(id: "FAKE_ID15", firstName: "User", lastName: "Pan", longitude: -122.461297, latitude: 37.860506)
    fileprivate let myfriend16 = Friend(id: "FAKE_ID16", firstName: "123", lastName: "Pan", longitude: -122.411297, latitude: 37.870506)
    fileprivate let myfriend17 = Friend(id: "FAKE_ID17", firstName: "456", lastName: "Pan", longitude: -122.411297, latitude: 37.880506)
    fileprivate let myfriend18 = Friend(id: "FAKE_ID18", firstName: "Iron Man", lastName: "Pan", longitude: -122.371297, latitude: 37.890506)
    fileprivate let myfriend19 = Friend(id: "FAKE_ID19", firstName: "Thanos", lastName: "Pan", longitude: -122.301297, latitude: 37.900506)
    fileprivate let myfriend20 = Friend(id: "FAKE_ID20", firstName: "Riven", lastName: "Pan", longitude: -122.361297, latitude: 40.900506)

    fileprivate let locationManager = CLLocationManager()

    var friendDetailView: FriendDetailView?

    var mostRecentUserLocation: CLLocation? = CLLocation(latitude: 37.780506, longitude: -122.431297)

    var assets: [MyModels] = [
        MyModels(object: MDLAsset(url: Bundle.main.url(forResource: "stickman", withExtension: "obj")!).object(at: 0))
    ]

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
                    let number = 0
                    let newNode: SCNNode = newFriendNode(fModel: assets[number].object, texture: assets[number].texture)
                    friendNodes[friend.id] = newNode

                    newNode.position = friend.sceneKitCoordinate(relativeTo: userLocation)
                    newNode.rotation = friend.sceneKitRotation()
                    var d: Double = friend.location.distance(from: userLocation)
                    if d < 1 {
                        d = 1
                    }
                    if d > 20000 {
                        d = 20000
                    }
                    let norm = 1 / log2(d)
                    let scaleFactor = 0.1 * norm
                    newNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
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
        friends = [myfriend, myfriend1, myfriend2, myfriend3, myfriend4, myfriend5, myfriend6, myfriend7, myfriend8, myfriend9, myfriend10, myfriend11, myfriend12, myfriend13, myfriend14, myfriend15, myfriend16, myfriend17, myfriend18, myfriend19, myfriend20]
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
        if let existingDetailView = friendDetailView {
            existingDetailView.removeFromSuperview()
            friendDetailView = nil
        }
        let location = sender.location(in: sceneView)

        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            print(hitResults.count)
            guard let friendNode = hitResults.first?.node else {
                return
            }

            var id: String?

            for (key, val) in friendNodes {
                if val == friendNode {
                    id = key
                }
            }

            guard id != nil,
                let friend = friends.first(where: { $0.id == id }) else {
                    return
            }

            addDetailView(for: friend, in: friendNode)
        }
    }

    func addDetailView(for friend: Friend, in node: SCNNode) {
        guard let userLocation = mostRecentUserLocation else {
            return
        }

        let detailView: FriendDetailView

        if let existingDetailView = friendDetailView {
            detailView = existingDetailView
            detailView.update(with: friend, relativeTo: userLocation)
        } else {
            detailView = FriendDetailView()
            friendDetailView = detailView
            detailView.update(with: friend, relativeTo: userLocation)
            view.addSubview(detailView)

            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            detailView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }

        detailView.alpha = 0
        updatePositionOfDetailView()
    }

    func updatePositionOfDetailView() {
        guard let detailView = friendDetailView,
            let friend = detailView.friend,
            let node = friendNodes[friend.id] else { return }

        let centerPoint = node.position
        let projectedPoint = sceneView.projectPoint(centerPoint)

        let translate = CGAffineTransform(
            translationX: CGFloat(projectedPoint.x) - detailView.intrinsicContentSize.width/2.2,
            y: CGFloat(projectedPoint.y) + 36)

        let translateAndScale = translate.scaledBy(x: 0.65, y: 0.65)

        DispatchQueue.main.async {
            detailView.transform = translateAndScale
            UIView.animate(withDuration: 0.3, animations: {
                detailView.alpha = 1.0
            })
            //if z if less than 1, then the point is behind the camera
            // this is a little buggy sometimes.
            if projectedPoint.z > 1 {
//                detailView.alpha = 0.0
            } else {
                detailView.alpha = 1.0
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        updatePositionOfDetailView()
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
        let friendAssetUrl = Bundle.main.url(forResource: "girl", withExtension: "obj")!
        return MDLAsset(url: friendAssetUrl).object(at: 0)
    }()

    private func newFriendNode(fModel: MDLObject, texture: UIImage? = nil) -> SCNNode {
        let friendNode = SCNNode(mdlObject: fModel)

        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = { () -> UIColor in
            return UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max),
                           green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                           blue: CGFloat(arc4random()) / CGFloat(UInt32.max), alpha: 1.0)
        }()
        if let texture = texture {
            planeMaterial.diffuse.contents = texture
        }
        friendNode.geometry?.materials = [planeMaterial]

        return friendNode
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
