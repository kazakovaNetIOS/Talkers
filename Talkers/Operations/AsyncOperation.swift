//
//  AsyncOperation.swift
//  Talkers
//
//  Created by Natalia Kazakova on 15.10.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
  enum State: String {
    case isReady
    case isExecuting
    case isFinished
  }

  var state: State = .isReady {
    willSet(newValue) {
      willChangeValue(forKey: state.rawValue)
      willChangeValue(forKey: newValue.rawValue)
    }
    didSet {
      didChangeValue(forKey: oldValue.rawValue)
      didChangeValue(forKey: state.rawValue)
    }
  }

  override var isAsynchronous: Bool { true }
  override var isExecuting: Bool { state == .isExecuting }
  override var isFinished: Bool {
    if isCancelled && state != .isExecuting { return true }
    return state == .isFinished
  }

  func execute() { }

  override func start() {
    guard !isCancelled else { return }

    state = .isExecuting

    execute()

    self.state = .isFinished
  }
}