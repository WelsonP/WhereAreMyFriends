//
//  FriendDetailView.swift
//  WhereAreMyFriends
//
//  Created by Welson Pan on 4/25/19.
//  Copyright © 2019 Welson Pan. All rights reserved.
//

import CoreLocation
import UIKit

class FriendDetailView: UINibView {
    private(set) var friend: Friend?

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
    }

    func configureViewWithFriend(_ friend: Friend) {

    }

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var distance: UILabel!

    // MARK: - Setup

    override var nibName: String {
        return "FriendDetailView"
    }

    override func nibWasLoaded() {
        self.translatesAutoresizingMaskIntoConstraints = false

        widthAnchor.constraint(equalToConstant: intrinsicContentSize.width).isActive = true
        heightAnchor.constraint(equalToConstant: intrinsicContentSize.height).isActive = true

        nibView.layer.cornerRadius = 10.0
        nibView.layer.masksToBounds = true

        layer.masksToBounds = false
        clipsToBounds = false
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 400, height: 150)
    }


    // MARK - Updating

    func updateForPrivateFlight(_ friend: Friend) {
        self.friend = friend
    }

    func update(
        with friend: Friend,
        relativeTo userLocation: CLLocation)
    {
        self.friend = friend

        name.text = friend.firstName

        let distanceMeters = friend.location.distance(from: userLocation)

        if distanceMeters < 1000.0 {
            distance.text = "\(Int(round(distanceMeters)))m away"
        } else {
            let rounded: Double = Double(round(((distanceMeters / 1000.0)) * 10)) / 10.0
            distance.text = "\(rounded) km away"
        }

        avatar.image = UIImage(named: "defaultAvatar.png")

        //load image from URL
//        guard let logoImageView = self.logoImageView else { return }
//
//        let imageTask = URLSession.shared.dataTask(with: URL(string: info.airlineLogoUrl)!, completionHandler: { data, _, _ in
//            guard let data = data, let image = UIImage(data: data) else {
//                DispatchQueue.main.async {
//                    logoImageView.image = #imageLiteral(resourceName: "generic airline")
//                    self.showOverlay(nil)
//                }
//
//                return
//            }
//
//            DispatchQueue.main.async {
//                logoImageView.image = image
//                self.showOverlay(nil)
//            }
//        })
//
//        imageTask.resume()
    }
}

///helper class to reduce boilerplate of loading from Nib
open class UINibView : UIView {

    var nibView: UIView!

    open var nibName: String {
        get {
            print("UINibView.nibName should be overridden by subclass")
            return ""
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }

    func setupNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        nibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        nibView.frame = bounds
        nibView.layer.masksToBounds = true

        self.addSubview(nibView)

        nibView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .left, .right, .bottom]
        for attribute in attributes {
            let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: self.nibView, attribute: attribute, multiplier: 1.0, constant: 0.0)
            self.addConstraint(constraint)
        }

        nibWasLoaded()
    }

    open func nibWasLoaded() {

    }

}
