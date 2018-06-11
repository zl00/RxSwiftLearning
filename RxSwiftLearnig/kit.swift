//
//  helper.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/7/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - sync programmer should make sure the call order
func __🍚() { print("🍚") }
func __😴() { print("😴") }
func __打🐧() { print("打🐧") }

// MARK: - async maybe closure, maybe notification to make sure the call order
func __async🍚(_ callback: @escaping(_ text: String) -> Void) {
  DispatchQueue.global().async {
    callback("🍚")
    print("🍚")
  }
}
func __async😴(_ callback: @escaping(_ text: String) -> Void) {
  DispatchQueue.global().asyncAfter(deadline: .now()+1) {
    callback("😴")
    print("😴")
  }
}
func __async打🐧(_ callback: @escaping(_ text: String) -> Void) {
  DispatchQueue.global().async {
    callback("打🐧")
    print("打🐧")
  }
}

// MARK: - async Just chain the singal
func __async🍚Signal() -> Observable<String> {
  return Observable<String>.create({ observer -> Disposable in
    observer.onNext("🍚")
//    observer.onCompleted() // MARK:🐠 concat没有这句，concat后面那个信号无法执行
    return Disposables.create()
  })
}
func __async😴Signal() -> Observable<String> {
  return Observable<String>.create({ observer -> Disposable in
    DispatchQueue.global().asyncAfter(deadline: .now()+1, execute: {
      observer.onNext("😴")
//      observer.onCompleted() // MARK:🐠 concat没有这句，concat后面那个信号无法执行
    })
    return Disposables.create()
  })
}
func __async打🐧Signal() -> Observable<String> {
  return Observable<String>.create({ observer -> Disposable in
    observer.onNext("打🐧")
    return Disposables.create()
  })
}

func __random(_ n: Int = 4) -> Int { // 产生100以内的随机数
  return Int(arc4random()) % n
}
