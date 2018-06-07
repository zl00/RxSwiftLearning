//
//  Error.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/7/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation

class MyError {
  static var `default`: NSError {
    return NSError.init(domain: "", code: -1, userInfo: nil)
  }
  
}
