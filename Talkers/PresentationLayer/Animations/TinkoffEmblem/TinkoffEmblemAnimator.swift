//
//  TinkoffEmblemAnimator.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol TinkoffEmblemAnimatorProtocol {
  func addEmitterLayer(to view: UIView, in position: CGPoint)
  func startAnimation()
  func stopAnimation()
}

class TinkoffEmblemAnimator {
  static let shared = TinkoffEmblemAnimator()
  private init() {}
  
  lazy var emblemEmitterLayer: CAEmitterLayer? = {
    guard let cell = self.createEmblemEmitterCell() else { return nil }

    let layer = CAEmitterLayer()
    layer.emitterShape = .point
    layer.renderMode = .unordered
    layer.emitterCells = [cell]

    return layer
  }()
}

// MARK: - TinkoffEmblemAnimatorProtocol

extension TinkoffEmblemAnimator: TinkoffEmblemAnimatorProtocol {
  func addEmitterLayer(to view: UIView, in position: CGPoint) {
    guard let layer = emblemEmitterLayer else { return }

    view.layer.addSublayer(layer)
    layer.position = position
  }

  func startAnimation() {
    emblemEmitterLayer?.birthRate = 5.0
  }

  func stopAnimation() {
    emblemEmitterLayer?.birthRate = 0.0
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
      self?.emblemEmitterLayer?.removeFromSuperlayer()
    }
  }
}

// MARK: - Private

private extension TinkoffEmblemAnimator {
  func createEmblemEmitterCell() -> CAEmitterCell? {
    guard let image = UIImage(named: "tinkoffEmblem")?.cgImage else { return nil }

    let tinkoffEmblemCell = CAEmitterCell()
    tinkoffEmblemCell.contents = image
    tinkoffEmblemCell.emissionRange = .pi
    tinkoffEmblemCell.lifetime = 1.0
    tinkoffEmblemCell.birthRate = 5.0
    tinkoffEmblemCell.scale = 0.05
    tinkoffEmblemCell.scaleRange = 0.1
    tinkoffEmblemCell.velocity = 80.0
    tinkoffEmblemCell.velocityRange = 60.0
    tinkoffEmblemCell.spin = -0.5
    tinkoffEmblemCell.spinRange = 10.0

    return tinkoffEmblemCell
  }
}
