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
  func __generateColdSignal() -> Observable<String> {
    
    return Observable<String>
      .create { observer -> Disposable in
        let words = "HELLO to ✨✨rx world✨✨"
        print("🎃 => __generateColdSignal")
        print(words)
        
        observer.onNext(words)
        observer.onCompleted()
        observer.onNext("XXX") // 🐠 Observable - 3: next after completed
        
        return Disposables.create()
    }
  }
  
  func shareObservable() {
    
    example(of: "Observable - Glance") {
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
    
    

  }
  
  func shareOperatorFilter() {
    example(of: "distinctUntilChanged") {
      Observable.of("A", "A", "B", "B", "A")
        .distinctUntilChanged()
        .subscribe(onNext: {
          print($0)
        })
        .disposed(by: bagShare)
    }
    
    
    
    example(of: "Scenario XXX") { // TODO:
    }
  }
  
  func shareOperatorTransform() {
    
  }
  
  func shareOperatorCombine() {
    example(of: "combine") {
      __async😴Signal().concat(__async打🐧Signal())
        .subscribe(onNext: { (text) in
          print(text)
        }, onError: { e in
          print(e)
        }, onCompleted: {
          print("over")
        })
        .disposed(by: bagShare)
    }
    
    example(of: "merge") {
      let sub1 = PublishSubject<Int>()
      let sub2 = PublishSubject<Int>()
      
      Observable.of(sub1, sub2).merge()
        .subscribe(
          onNext: { element in
            print("\(element)")
          }
          , onError: {
            print("\($0)")
          }, onCompleted: {
            print("merge.over")
        })
        .disposed(by: bagShare)
      
      sub1.onNext(1)
      sub2.onNext(11)
//      sub1.onError(NSError.init(domain: "23", code: -1, userInfo: nil))
      sub1.onCompleted()
      sub2.onNext(12)
      sub2.onCompleted()
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
  
  func sharePitfalls() {
    
    example(of: "Subscribe multi times") {
      let observable = __generateColdSignal() // share
      
      observable
        .subscribe(onNext: { _ in
          print("🐾🐾🐾🐾🐾🐾🐾🐾")
        })
        .disposed(by: bagShare)
      
      observable
        .subscribe(onNext: { _ in
          print("🐈🐈🐈🐈🐈🐈🐈🐈")
        })
        .disposed(by: bagShare)
    }
    
    
    
  }
  
}
