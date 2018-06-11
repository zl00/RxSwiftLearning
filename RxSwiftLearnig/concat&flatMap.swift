//
//  flatMap.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/7/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

let bag = DisposeBag()

extension ViewController {
  func linda_concat() {
    example(of: "concat") { // MARK: keep things happen in line.
      __async🍚Signal()
        .concat(__async😴Signal())
        .concat(__async打🐧Signal())
        .subscribe(onNext: { print("=> \($0)") })
        .disposed(by: bag)
    }
  }
  
  func linda_flatMap() { // MARK: producer - consumer
    
    let __foods = ["🍨", "🍲", "🥗", "🍭"]
    let __flavor = ["😋", "🙄", "😭", "🤢"]
    
    func __produceFoods() -> Observable<String> {
      return Observable<String>.create({ observer -> Disposable in
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {_ in
          
          let product = __foods[__random()]
          print("Produced=>\(product)")
          observer.onNext("\(product)")
        })
        return Disposables.create()
      })
    }
    
    func __consumeFood(_ food: String) -> Observable<String> {
      return Observable<String>.create { observer -> Disposable in
        
        let consumer = __flavor[__random()]
        observer.onNext("\(food) tastes \(consumer)")
        return Disposables.create()
      }
    }
    
    example(of: "flatMap") {
      __produceFoods()
        .flatMap { food in return __consumeFood(food) }
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
    }
  }
}
