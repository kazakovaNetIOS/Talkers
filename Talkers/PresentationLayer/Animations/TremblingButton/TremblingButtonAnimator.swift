//
//  TremblingButtonAnimator.swift
//  Talkers
//
//  Created by Natalia Kazakova on 26.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol TremblingButtonAnimatorProtocol {
  func animate(_ button: UIButton)
}

class TremblingButtonAnimator {

}

extension TremblingButtonAnimator: TremblingButtonAnimatorProtocol {
  func animate(_ button: UIButton) {
    button.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = -.pi / 180.0 * 18.0
    rotate.toValue = .pi / 180.0 * 18.0

    let upDownMove = CABasicAnimation(keyPath: "position.y")
    upDownMove.fromValue = button.layer.position.y + 1.33 * 5.0
    upDownMove.fromValue = button.layer.position.y - 1.33 * 5.0

    let leftRightMove = CABasicAnimation(keyPath: "position.x")
    leftRightMove.fromValue = button.layer.position.x + 1.33 * 5.0
    leftRightMove.fromValue = button.layer.position.x - 1.33 * 5.0

    let groupAnimation = CAAnimationGroup()
    groupAnimation.duration = 0.3
    groupAnimation.animations = [rotate, upDownMove]
    groupAnimation.repeatCount = .infinity
    groupAnimation.autoreverses = true

    button.layer.add(groupAnimation, forKey: nil)
  }
}
