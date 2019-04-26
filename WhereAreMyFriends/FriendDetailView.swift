//
//  FriendDetailView.swift
//  WhereAreMyFriends
//
//  Created by Welson Pan on 4/25/19.
//  Copyright © 2019 Welson Pan. All rights reserved.
//

import UIKit

class FriendDetailView: UIView {
    var friend: Friend?

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
    }

    func configureViewWithFriend(_ friend: Friend) {

    }
}
