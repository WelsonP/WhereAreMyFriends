//
//  MyFriends.swift
//  WhereAreMyFriends
//
//  Created by Tony Zhang on 4/25/19.
//  Copyright © 2019 Welson Pan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import ModelIO
import SceneKit.ModelIO

class MyModels {
    var object: MDLObject
    var texture: UIImage?

    init(object: MDLObject, texture: UIImage? = nil) {
        self.object = object
        self.texture = texture
    }
}
