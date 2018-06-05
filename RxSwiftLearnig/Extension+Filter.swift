//
//  Extension+Filter.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 5/31/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  
  func learnFilter() {
    example(of: "[ignoreElements] - 🦍 Focus on the terminated status") { // 🦍
      let strikes = PublishSubject<String>()
      let disposeBag = DisposeBag()

      strikes
        .ignoreElements()
        .subscribe { _ in
          print("You're out!")
        }
        .disposed(by: disposeBag)
      
      strikes.onNext("X")
      strikes.onNext("X")
      strikes.onNext("X")
      strikes.onCompleted()
    }
    
    example(of: "[elementAt]") {
      let strikes = PublishSubject<String>()
      let disposeBag = DisposeBag()
      
      //  2
      strikes
        .elementAt(2)
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
      
      strikes.onNext("X1")
      strikes.onNext("X2")
      strikes.onNext("X3")
    }
    
    example(of: "filter") {
      let disposeBag = DisposeBag()
      Observable.of(1, 2, 3, 4, 5, 6)
        .filter { integer in
          integer % 2 == 0
        }
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
    }
  
    example(of: "skip") {
      let disposeBag = DisposeBag()
      Observable.of("A", "B", "C", "D", "E", "F")
        .skip(3)
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
    }
    
    example(of: "[skipWhile] - Skip until meet the element which satifies condition") {
      let disposeBag = DisposeBag()
      Observable.of(2, 2, 3, 4, 4)
        .skipWhile { integer in
          integer % 2 == 0
        }
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
    }
    
    example(of: "[skipUntil] - 🦍 wait next event of trigger") {
      let disposeBag = DisposeBag()
      let subject = PublishSubject<String>()
      let trigger = PublishSubject<String>()

      subject
        .skipUntil(trigger)
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
      
      subject
        .subscribe(onNext: {
          print(" == > \($0)")
        })
        .disposed(by: disposeBag)
      
      subject.onNext("A")
      subject.onNext("B")
      
      trigger.onNext("Switch ON!")
      
      subject.onNext("C")
    }
  
    example(of: "[take] 🦍🦍 Take is opposed to skip...") {
      let disposeBag = DisposeBag()
      Observable.of(1, 2, 3, 4, 5, 6)
        .take(3)
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
    }
  
    example(of: "distinctUntilChanged - 🦍") {
      let disposeBag = DisposeBag()
      Observable.of("A", "A", "B", "B", "A")
        .distinctUntilChanged()
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: disposeBag)
    }
    
    var start = 0
    func getStartNumber() -> Int {
      start += 1
      return start
    }
    
    example(of: "[🦍🦍Problems🦍🦍] - subscribe the same observable multiple times") {
      let numbers = Observable<Int>.create { observer in
        print ("Observable.create")
        let start = getStartNumber()
        observer.onNext(start)
        observer.onNext(start+1)
        observer.onNext(start+2)
        observer.onCompleted()
        return Disposables.create()
      }
      
      numbers
        .subscribe(onNext: { el in
          print("element [\(el)]")
        }, onCompleted: {
          print("-------------")
        })
      
      numbers
        .subscribe(onNext: { el in
          print("element [\(el)]")
        }, onCompleted: {
          print("-------------")
        })
    }
  }
}
