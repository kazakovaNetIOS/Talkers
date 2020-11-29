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
    if isPresenting {
      present(using: transitionContext)
    } else {
      dismiss(using: transitionContext)
    }
  }
}

// MARK: - Private

private extension CircleTransitionAnimator {
  func present(using transitionContext: UIViewControllerContextTransitioning) {
    guard let presentedVC = transitionContext.viewController(forKey: .to),
          let presentedView = transitionContext.view(forKey: .to) else {
      transitionContext.completeTransition(false)
      return
    }

    let containerView = transitionContext.containerView
    let finalFrame = transitionContext.finalFrame(for: presentedVC)
    let startButtonFrame = presentationStartButton.convert(presentationStartButton.bounds, to: containerView)
    let startButtonCenter = CGPoint(x: startButtonFrame.midX, y: startButtonFrame.midY)

    let circleView = createCircle(for: presentedView)

    containerView.addSubview(circleView)
    containerView.addSubview(presentedView)

    presentedView.center = startButtonCenter
    presentedView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)

    circleView.center = presentedView.center
    circleView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)

    UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
      presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      presentedView.frame = finalFrame

      circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      circleView.center = presentedView.center
    } completion: { (finished) in
      circleView.removeFromSuperview()
      transitionContext.completeTransition(finished)
    }
  }

  func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
    guard let dismissedView = transitionContext.view(forKey: .from),
          let presentedView = transitionContext.view(forKey: .to) else {
      transitionContext.completeTransition(false)
      return
    }

    let containerView = transitionContext.containerView
    let startButtonFrame = presentationStartButton.convert(presentationStartButton.bounds, to: containerView)
    let startButtonCenter = CGPoint(x: startButtonFrame.midX, y: startButtonFrame.midY)

    let circleView = createCircle(for: dismissedView)
    circleView.center = presentedView.center

    containerView.insertSubview(presentedView, belowSubview: dismissedView)
    containerView.insertSubview(circleView, belowSubview: dismissedView)

    UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
      dismissedView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
      dismissedView.center = startButtonCenter

      circleView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
      circleView.center = startButtonCenter
    } completion: { (finished) in
      circleView.removeFromSuperview()
      transitionContext.completeTransition(finished)
    }
  }

  func createCircle(for view: UIView) -> UIView {
    let d = sqrt(view.bounds.width * view.bounds.width + view.bounds.height * view.bounds.height)
    let circleView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: d, height: d))
    circleView.layer.cornerRadius = d / 2
    circleView.layer.masksToBounds = true
    circleView.backgroundColor = view.backgroundColor
    return circleView
  }
}
