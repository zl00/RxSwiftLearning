//
//  Extension+Transform.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 5/31/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  func learnTransforming() {
    example(of: "toArray") {
      let disposeBag = DisposeBag()
      Observable.of("A", "B", "C")
        .toArray()
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
    }
    
    example(of: "map") {
      let disposeBag = DisposeBag()
      let formatter = NumberFormatter()
      formatter.numberStyle = .spellOut
      
      let observable = Observable<NSNumber>.of(123, 4, 56)
      observable
        .map {
          formatter.string(from: $0) ?? ""
        }
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
      
      observable
        .subscribe(onNext: {
          print(" ==> \($0)")
        })
        .disposed(by: disposeBag)
    }
    
    example(of: "enumerated and map") {
      let disposeBag = DisposeBag()
      Observable.of(1, 2, 3, 4, 5, 6)
        .enumerated()
        .map { index, integer in
          index > 2 ? integer * 2 : integer
        }
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
    }
    
    struct Student {
      var score: BehaviorSubject<Int>
    }
    
    example(of: "[flatMap] - 🦍🦍持续关注多个Topic") { // 多个source
      let disposeBag = DisposeBag()
      let ryan = Student(score: BehaviorSubject(value: 80))
      let charlotte = Student(score: BehaviorSubject(value: 90))
      let student = PublishSubject<Student>()
      
      student
        .debug()
        .flatMap { $0.score }
//        .subscribe(onNext: { print($0) })
        .subscribe(onNext: {
          print($0)
        }, onCompleted: {
          print("OVER!")
        })
        .disposed(by: disposeBag)
      
      student.onNext(ryan)
      ryan.score.onNext(85)
      ryan.score.onCompleted()

      student.onNext(charlotte)
      charlotte.score.onNext(95)
    }
    
    example(of: "[flatMapLatest] - 🦍🦍持续最近那个Topic") { // 最近source
      let disposeBag = DisposeBag()
      let ryan = Student(score: BehaviorSubject(value: 80))
      let charlotte = Student(score: BehaviorSubject(value: 90))
      let student = PublishSubject<Student>()
    
      student
        .flatMapLatest { $0.score }
        .subscribe(onNext: {
          print($0)
        }, onCompleted: {
          print("OVER!")
        })
//        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
      student.onNext(ryan)
      ryan.score.onNext(85)
    
      student.onNext(charlotte)
      ryan.score.onNext(86)
      charlotte.score.onNext(100)
      ryan.score.onNext(87)
      
      let vari = Variable<String>("1")
      vari.value = "2"
      vari.value = "3"
      vari.asObservable()
        .subscribe(onNext: { print("hello \($0)") })
        .disposed(by: disposeBag)
    }
    
    example(of: "materialize and dematerialize") {
      enum MyError: Error {
        case anError
      }
    
      let disposeBag = DisposeBag()
      let ryan = Student(score: BehaviorSubject(value: 80))
      let charlotte = Student(score: BehaviorSubject(value: 100))
      let student = BehaviorSubject(value: ryan)
      let studentScore = student
        .flatMapLatest {
          $0.score.materialize() // 🦍不加materialize，studentScore会因为某个topic发生error而中断
      }
      
      studentScore
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
      
      ryan.score.onNext(85)
      ryan.score.onError(MyError.anError)
      ryan.score.onNext(90)
      
      student.onNext(charlotte)
    }
  }
}
