//
//  Extension+Combine.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/1/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController { // TODO: - Linda
  
  func learnCombine() {
    let bag = DisposeBag()
    
    example(of: "startWith") {
      let numbers = Observable.of(2, 3, 4)
      let observable = numbers.startWith(1)
      observable
        .subscribe(onNext: { value in
          print(value)
        })
        .disposed(by: bag)
    }
    
    example(of: "Observable.concat") {
      let first = Observable.of(1, 2, 3)
      let second = Observable.of(4, 5, 6)
      let observable = Observable.concat([first, second])
      
      observable
        .subscribe(onNext: { value in
          print(value)
        })
        .disposed(by: bag)
      
      
    }
    
    example(of: "concat") {
      let germanCities = Observable.of("Berlin", "Münich", "Frankfurt")
      let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
      
      let observable = germanCities.concat(spanishCities)
      observable
        .subscribe(onNext: { value in
          print(value)
        })
        .disposed(by: bag)
    }
    
    example(of: "concatMap") {
      let sequences = [
        "Germany": Observable.of("Berlin", "Münich", "Frankfurt"),
        "Spain": Observable.of("Madrid", "Barcelona", "Valencia")
      ]
      
      Observable.of("Germany", "Spain")
        .concatMap { country in sequences[country] ?? .empty() }
        .subscribe(onNext: { print("\($0)") })
        .disposed(by: bag)
    }
    
    example(of: "merge") {
      let left = PublishSubject<String>()
      let right = PublishSubject<String>()
      let source = Observable.of(left.asObservable(), right.asObservable())
      
      let observable = source.merge()
      let disposable = observable.subscribe(onNext: { print($0) })
//      let disposable = source.subscribe(onNext: { print($0) })
      
      var leftValues = ["Berlin", "Munich", "Frankfurt"]
      var rightValues = ["Madrid", "Barcelona", "Valencia"]
      
      var count = 0
      repeat {
//        count += 1
//        if count == 4 {
//          left.onError(NSError.init(domain: "", code: -1, userInfo: nil))
//        }
        if arc4random_uniform(2) == 0 {
          if !leftValues.isEmpty {
            left.onNext("Left:  " + leftValues.removeFirst())
          }
        } else if !rightValues.isEmpty {
          right.onNext("Right: " + rightValues.removeFirst())
        }
      } while !leftValues.isEmpty || !rightValues.isEmpty
      
      disposable.dispose()
    }
    
    example(of: "combineLatest - contact") {
      let left1 = PublishSubject<String>()
      let left2 = PublishSubject<String>()
      let right = PublishSubject<String>()
      
      let observable = Observable.combineLatest(left1.concat(left2), right, resultSelector: { "\($0) - \($1)"})
      
      let disposable = observable
        .subscribe(onNext: { value in
          print(value)
        })
      
      print("> Sending a value to Left")
      left1.onNext("L1")
      left2.onNext("L2")
      print("> Sending a value to Right")
      right.onNext("R1")
      
    }
    
    example(of: "combineLatest") {
      let left = PublishSubject<String>()
      let right = PublishSubject<String>()
      let observable = Observable.combineLatest(left, right, resultSelector: { "\($0) - \($1)"})
      
      let disposable = observable
        .subscribe(onNext: { value in
          print(value)
        })

      print("> Sending a value to Left")
      left.onNext("L1")
      print("> Sending a value to Right")
      right.onNext("R1")
      print("> Sending another value to Right")
      right.onNext("R2")
      print("> Sending another value to Right")
      right.onNext("R3")
      print("> Sending another value to Left")
      left.onNext("L2")
      
      disposable.dispose()
    }
    
    example(of: "combine user choice and value") {
      let choice : Observable<DateFormatter.Style> = Observable.of(.short, .long)
      let dates = Observable.of(Date())
      
      let observable = Observable.combineLatest(choice, dates) {
        (format, when) -> String in
        let formatter = DateFormatter()
        formatter.dateStyle = format
        return formatter.string(from: when)
      }
      
      observable
        .subscribe(onNext: { value in
          print(value)
        })
        .disposed(by: bag)
    }
  
    example(of: "withLatestFrom") {
      let button = PublishSubject<Void>()
      let textField = PublishSubject<String>()
    
      let observable = button.withLatestFrom(textField)
      _ = observable.subscribe(onNext: { value in
        print(value)
      })
    
      textField.onNext("Par")
      textField.onNext("Pari")
      textField.onNext("Paris")
      button.onNext(())
      button.onNext(())
      textField.onNext("Parisssss")
    }
    
    example(of: "amb") {
      let left = PublishSubject<String>()
      let right = PublishSubject<String>()
    
      let observable = left.amb(right)
      let disposable = observable.subscribe(onNext: { value in
        print(value)
      })
    
      left.onNext("Lisbon")
      right.onNext("Copenhagen")
      left.onNext("London")
      left.onNext("Madrid")
      right.onNext("Vienna")
    
      disposable.dispose()
    }
    
    example(of: "switchLatest") {
      // 1
      let one = PublishSubject<String>()
      let two = PublishSubject<String>()
      let three = PublishSubject<String>()
    
      let source = PublishSubject<Observable<String>>()
      let observable = source.switchLatest()
//      let observable = source.flatMap { return $0 }
      let disposable = observable.subscribe(onNext: { print($0) })
      
      source.onNext(one)
      one.onNext("Some text from sequence one")
      two.onNext("Some text from sequence two")
      
      source.onNext(two)
      two.onNext("More text from sequence two")
      one.onNext("and also from sequence one")
      
      source.onNext(three)
      two.onNext("Why don't you see me?")
      one.onNext("I'm alone, help me")
      three.onNext("Hey it's three. I win.")
      
      source.onNext(one)
      one.onNext("Nope. It's me, one!")
      disposable.dispose()
    }
  }
}
