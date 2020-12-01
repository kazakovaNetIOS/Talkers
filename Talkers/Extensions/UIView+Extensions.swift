//
//  UIView+Extensions.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

extension UIView {
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let app = UIApplication.shared.delegate as? AppDelegate,
       let window = app.window {
      if let touch = event?.touches(for: window)?.first {
        let position = touch.location(in: self)
        TinkoffEmblemAnimator.shared.addEmitterLayer(to: self, in: position)
        TinkoffEmblemAnimator.shared.startAnimation()
      }
    }
    super.touchesBegan(touches, with: event)
  }

  open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let app = UIApplication.shared.delegate as? AppDelegate,
       let window = app.window {
      if let touch = event?.touches(for: window)?.first {
        let position = touch.location(in: self)
        TinkoffEmblemAnimator.shared.addEmitterLayer(to: self, in: position)
      }
    }
    super.touchesMoved(touches, with: event)
  }

  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    TinkoffEmblemAnimator.shared.stopAnimation()
    super.touchesEnded(touches, with: event)
  }

  open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    TinkoffEmblemAnimator.shared.stopAnimation()
    super.touchesEnded(touches, with: event)
  }
}
