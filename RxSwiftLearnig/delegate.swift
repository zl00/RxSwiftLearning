//
//  delegate.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/8/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation

protocol DataSourceDelegate {
  func didReceive(_ data: Int)
}

class Producer {
  var delegate: DataSourceDelegate?
  
  func produce() {
    let data = 1 // produce data
    delegate?.didReceive(data) // feed back data
  }
}

var producer = Producer()

class Consumer: DataSourceDelegate {
  
  func start() { producer.delegate = self }
  
  // MARK: - DataSourceDelegate
  func didReceive(_ data: Int) {
    // consume data
  }
}
