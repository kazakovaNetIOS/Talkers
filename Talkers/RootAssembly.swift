//
//  RootAssembly.swift
//  Talkers
//
//  Created by Natalia Kazakova on 09.11.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class RootAssembly {
  lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: serviceAssembly)
  private lazy var serviceAssembly: ServiceAssemblyProtocol = ServiceAssembly(coreAssembly: coreAssembly)
  private lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
}
