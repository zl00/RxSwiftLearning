//
//  reflectOnReal.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/7/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  func reflectOnReal1() {
    example(of: "reflectOnReal1") {
      __async🍚 {_ in }
      __async😴 {_ in }
      __async打🐧 {_ in }
    }
  }
  
  func reflectOnReal2() {
    example(of: "reflectOnReal2") {
      __async🍚 {_ in
        __async😴 {_ in
          __async打🐧() { _ in
            
          }
        }
      }
    }
  }
}
