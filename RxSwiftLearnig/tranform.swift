//
//  tranform.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/7/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  
  func linda_tranform() {
    
    example(of: "map") {
      Observable<Int>.from([1, 2, 3])
        .map { "✨String => \($0)✨" }
        .subscribe(onNext: { print($0) })
        .disposed(by: bagShare)
    }
    
    example(of: "✨✨flatMap-1✨✨") {
      Observable<Int>.from([1, 2, 3])
        .flatMap { return Observable<String>.just("✨String => \($0)✨") }
        .subscribe(
          onNext: { print($0) },
          onCompleted: { print("completed!")
        })
        .disposed(by: bagShare)
    }
    
    example(of: "✨✨flatMap-2✨✨") {
      struct Student {
        var score: BehaviorSubject<Int>
      }
      
      let Tom = Student(score: BehaviorSubject(value: 80))
      let Lucy = Student(score: BehaviorSubject(value: 90))
      let student = PublishSubject<Student>()
      
      student
        .flatMap { $0.score }
        .subscribe(onNext: {
          print($0)
        }, onError: {
          print($0)
        }, onCompleted: {
          print("OVER!")
        })
        .disposed(by: bag)
      
      student.onNext(Tom)
      Tom.score.onNext(85)
      Tom.score.onCompleted()
//      Tom.score.onError(MyError.default) // 🐠 onCompleted => onError, 断了
      
      student.onNext(Lucy)
      Lucy.score.onNext(95)
      Lucy.score.onCompleted()
    }
    
  }
}
