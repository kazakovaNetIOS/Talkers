//
//  TremblingButtonAnimator.swift
//  Talkers
//
//  Created by Natalia Kazakova on 26.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol TremblingButtonAnimatorProtocol {
  func animate(_ button: UIButton, editMode: Bool)
}

class TremblingButtonAnimator {

}

extension TremblingButtonAnimator: TremblingButtonAnimatorProtocol {
  func animate(_ button: UIButton, editMode: Bool) {
    guard editMode else {
      button.layer.removeAllAnimations()
      return
    }
    
    let rotateAngle: CGFloat = 18 * .pi / 180

    let rotate = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    rotate.values = [-rotateAngle, 0, rotateAngle]
    rotate.autoreverses = true
    rotate.duration = 0.15
    rotate.keyTimes = [0, 0.5, 1]
    rotate.repeatCount = .infinity

    let upDownMove = CAKeyframeAnimation(keyPath: "transform.translation.y")
    upDownMove.values = [0, 5.0, 0.0, -5.0]
    upDownMove.autoreverses = true
    upDownMove.duration = 0.15
    upDownMove.keyTimes = [0, 0.4, 0.8, 1.0]
    upDownMove.repeatCount = .infinity

    let leftRightMove = CAKeyframeAnimation(keyPath: "transform.translation.x")
    leftRightMove.values = [0, 5.0, 0.0, -5.0]
    leftRightMove.autoreverses = true
    leftRightMove.duration = 0.15
    leftRightMove.keyTimes = [0, 0.4, 0.8, 1.0]
    leftRightMove.repeatCount = .infinity

    let groupAnimation = CAAnimationGroup()
    groupAnimation.duration = 0.3
    groupAnimation.animations = [rotate, upDownMove, leftRightMove]
    groupAnimation.repeatCount = .infinity
    groupAnimation.autoreverses = true

    button.layer.add(groupAnimation, forKey: nil)
  }
}
