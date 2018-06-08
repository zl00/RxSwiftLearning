//
//  filter.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/7/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  func linda_filter() {
    example(of: "filter") {
      Observable<String>.from(["天选之人1", "我不是", "天选之人2", "What a pity. I'm not"])
        .filter { element -> Bool in
          return element.contains("天选之人")
        }
        .subscribe(onNext: { element in
          print("filtered result: \(element)")
        })
        .disposed(by: bag)
    }
    
    example(of: "throttle") { // 🐠见图片
      let textFieldVari = PublishSubject<String>()
      
      func __quickInput(_ text: String, _ time: Double) { // 延迟onNext
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
          textFieldVari.onNext(text)
        })
      }
      
      textFieldVari.asObservable()
        .throttle(8, scheduler: MainScheduler.instance) // MARK: [IMAGE:throttle.png]
        .subscribe(onNext: {
          print("throttle✨\($0)")
        })
        .disposed(by: bagShare)
      
      __quickInput("", 0.5)
      __quickInput("quick input", 1)
      __quickInput("quick input 1", 1.5)
      __quickInput("quick input 1234", 2)
    }
    
//    example(of: "take(_:scheduler)") {
//      let subject = PublishSubject<Int>()
//      subject.asObservable()
//        .take(5, scheduler: MainScheduler.instance)
//        .subscribe(onNext: { _ in
//          print("take(_:scheduler) => onNext")
//        }, onCompleted: {
//          print("take(_:scheduler) => Over!✨✨")
//        })
//        .disposed(by: bagShare)
//
//      DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: { // MARK: 更改dead的值，实现timeout
//        subject.onNext(2)
//      })
//    }
  }
}
