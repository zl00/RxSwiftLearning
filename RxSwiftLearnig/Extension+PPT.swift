//
//  Extension+PPT.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/5/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

let bagShare = DisposeBag()

extension ViewController {
  func reflectOnReal() {
    example(of: "reflect on existing programming") {
      func __🍚() { print("🍚") }
      func __😴() { print("😴") }
      func __打🐧() { print("打🐧") }
      
      __🍚(); __😴(); __打🐧()
//      __🍚(); __打🐧(); __😴() // 🐠 reflect - 最经常遇到的一个函数间关系：order
    }
  }
  
  func shareObservable() {
    
    func __generateColdSignal() -> Observable<String> {
      
      return Observable<String>
        .create { observer -> Disposable in
          let words = "HELLO to ✨✨rx world✨✨"
          print("🎃 => __generateColdSignal")
          print(words)
          
          observer.onNext(words)
          observer.onCompleted()
          observer.onNext("Hello again!") // 🐠 Observable - 3: next after completed
          
          return Disposables.create()
      }
    }
    
    example(of: "Observable - Cold") {
      _ = __generateColdSignal()
        .subscribe( // 🐠 Observable - 1: cold
          onNext: {
            print("🎃 => onNext")
            print($0)
          },
          onCompleted: {
            print("🎃 => onCompleted")
          }
        )
        .disposed(by: bagShare) // 🐠 Observable - 2: bag
    }
    
    example(of: "Observable - Have a glance of error handling") {
    }
    
    example(of: "Observable - Why need subject") {
    }
  }
  
  func shareOperators() {
    example(of: "Operator - Filter") {
    }
    
    example(of: "Operator - Transform") {
    }
    
    example(of: "Operator - Combine") {
    }
    
    example(of: "Scenario XXX") { // TODO:
    }
  }
  
  func shareScheduler() {
    example(of: "Scheduler - subscribeOn (producer role) - computing") {
    }
    
    example(of: "Scheduler - subscribeOn🦍🦍Pitfalls") {
    }
    
    example(of: "Scheduler - observeOn (consumer role)") {
    }
  }
  
  func shareMVVM() { // TODO: 需要另一个项目
    // data -- binding --> ui
    // ui -- trigger --> action
  }
  
}
