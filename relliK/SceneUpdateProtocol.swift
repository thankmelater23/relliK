//
//  SceneUpdateProtocol.swift
//  relliK
//
//  Created by Andre on 2/11/18.
//  Copyright © 2018 Bang Bang Studios. All rights reserved.
//

import Foundation

@objc protocol SceneUpdateProtocol: class {
    @objc optional func killCountUpdate()
    @objc optional func pointCountUpdate(points: Int)
    @objc optional func errorCountUpdate()
}
