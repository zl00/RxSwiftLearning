//
//  Extension+Subject.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 5/31/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  func learnSubject() {
    let bag = DisposeBag()
    
    example(of: "[PublishSubject] - PS only emits to current subscribers") {
      let subject = PublishSubject<String>()
      subject.onNext("How are you?") // 🐶
      
      let subscriptionOne = subject.subscribe(onNext: { print($0) })
      subject.on(.next("1")) // 🐶
      
      var vari = Variable<String>("1111")
      vari.asObservable()
        .subscribe { print($0) }
        .disposed(by: bag)
      
      vari = Variable<String>("")
      print("Over")
    }
    
    var start = 1
    func __changeStart() -> Int { start += 1; return start }
    
    example(of: "[🦍🦍]") {
      let subject = PublishSubject<Int>()
      
      subject.asObservable()
        .subscribe(onNext: {
          print(" => \($0)")
        })
        .disposed(by: bag)
      
      subject.asObservable()
        .subscribe(onNext: {
          print(" => \($0)")
        })
        .disposed(by: bag)
      
      subject.onNext(__changeStart())
    }
    
    example(of: "[Variable<[Int]>]") {
      let vari = Variable<[Int]>([])
      vari.asObservable()
        .skip(1)
        .subscribe(onNext: { print("\($0)")})
        .disposed(by: bag)
      
      vari.value.append(10)
      vari.value.append(11)
      vari.value = [1, 2, 3]
      vari.value = [1, 2, 4]
    }
  }

  // MARK: -  🦍
  /**
   PublishSubject：过期不候
   BehaviorSubject: 一个snapshot
   ReplaySubject: 一段历史
   Variable: like BehaviorSubject. And use most.🦍🦍
   */
}
