//
//  FlipPresentAnimationController.swift
//  Talkers
//
//  Created by Natalia Kazakova on 28.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import UIKit

class CircleTransitionAnimator: NSObject {
  private let presentationStartButton: UIView
  private let isPresenting: Bool

  init(presentationStartButton: UIView,
       isPresenting: Bool) {
    self.presentationStartButton = presentationStartButton
    self.isPresenting = isPresenting
  }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension CircleTransitionAnimator: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let presentedVC = transitionContext.viewController(forKey: .to),
          let presentedView = transitionContext.view(forKey: .to) else {
      transitionContext.completeTransition(false)
      return
    }

    let containerView = transitionContext.containerView
    let finalFrame = transitionContext.finalFrame(for: presentedVC)
    let startButtonFrame = presentationStartButton.convert(presentationStartButton.bounds, to: containerView)
    let startButtonCenter = CGPoint(x: startButtonFrame.midX, y: startButtonFrame.midY)

    let circelView = createCircle(for: presentedView)

    containerView.addSubview(circelView)
    containerView.addSubview(presentedView)

    presentedView.center = startButtonCenter
    presentedView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)

    circelView.center = presentedView.center
    circelView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)

    UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
      presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      presentedView.frame = finalFrame

      circelView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      circelView.center = presentedView.center
    } completion: { (finished) in
      transitionContext.completeTransition(finished)
    }
  }
}

// MARK: - Private

private extension CircleTransitionAnimator {
  func createCircle(for view: UIView) -> UIView {
    let d = sqrt(view.bounds.width * view.bounds.width + view.bounds.height * view.bounds.height)
    let circleView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: d, height: d))
    circleView.layer.cornerRadius = d / 2
    circleView.layer.masksToBounds = true
    circleView.backgroundColor = view.backgroundColor
    return circleView
  }
}
