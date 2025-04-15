//
//  CoordinatorProtocol.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import Foundation

protocol CoordinatorProtocol: AnyObject {
  var children: [CoordinatorProtocol] { get set }
  
  func start()
}
