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
  
  func reflectOnReal() {
    example(of: "reflect on existing programming") {
      func __🍚() { print("🍚") }
      func __😴() { print("😴") }
      func __打🐧() { print("打🐧") }
      
      __🍚(); __😴(); __打🐧()
//      __🍚(); __打🐧(); __😴() // 🐠 reflect - 最常遇到的一个函数间关系：order
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
    
    example(of: "Observable.Traits.Single") {
      func _readText() throws -> String { return "blabla" }
      func _readTextSignal(_ flag: Bool) -> Single<String> {
        
        return Single.create(subscribe: { single -> Disposable in
          // SingleEvent // 🐠 Observable.Traits - 1: 看一下它的定义
          if flag { single(.success("success")); single(.success("success2")) } // 🐠 Observable.Traits - 3 `single(.success("success2"))` is ignored
          else { single(.error(NSError.init(domain: "error", code: -1, userInfo: nil))) }
          
          return Disposables.create()
        })
      }
      
      // 🐠 Observable.Traits - 2: 敲一下subscribe，发现指定了函数是onSuccess, onError
      _ = _readTextSignal(true)
        .subscribe(
          onSuccess: {
            print("✨✨\($0)✨✨")
          },
          onError: {
            print("✨✨\($0)✨✨")
          }
        )
        .disposed(by: bagShare)
    }
    
    example(of: "Observable.Traits.Completable") {
      func __isOK() -> Bool { return true }
      func __isOKSignal(_ flag: Bool) -> Completable {
        return Completable.create(subscribe: { completable -> Disposable in
          // CompletableEvent
          if flag {
            completable(.completed)
          } else {
            completable(.error(NSError.init(domain: "Error", code: -1, userInfo: nil)))
          }
          return Disposables.create()
        })
      }
      
      _ = __isOKSignal(true)
        .subscribe(
          onCompleted: {
            print("✨✨completed✨✨")
        },
          onError: {
            print("✨✨\($0)✨✨")
        }
        )
        .disposed(by: bagShare)
    }
    
    example(of: "Observable - Why need subject") {
      let vari = Variable<Int>(1) // 🐠 Subject - 1看一下Variable的仅有的2个方法
      vari.value = 2
      vari.value = 3
      vari.asObservable()
        .subscribe(onNext: {
          print("✨✨\($0)✨✨") // 🐠 Subject - 2 Guess what will be printed?
        })
        .disposed(by: bagShare)
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
    
    example(of: "take(_:scheduler)") {
      PublishSubject<Int>().asObservable()
        .take(5, scheduler: MainScheduler.instance)
        .subscribe(onNext: { _ in
          print("onNext")
        }, onError: {
          print("Error:\($0)")
        }, onCompleted: {
          print("take(_:scheduler)✨✨Over!✨✨")
        })
        .disposed(by: bagShare)
    }
    
    example(of: "throttle") {
      let textFieldVari = PublishSubject<String>()
      func __quickInput(_ text: String, _ time: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
          textFieldVari.onNext(text)
        })
      }
      
      textFieldVari.asObservable()
        .throttle(8, scheduler: MainScheduler.instance)
        .subscribe(onNext: {
          print("throttle✨✨\($0)✨✨")
        })
        .disposed(by: bagShare)
      
      __quickInput("quick", 0.5)
      __quickInput("quick input", 1)
      __quickInput("quick input 1", 1.5)
      __quickInput("quick input 1234", 2)
    }
    
    example(of: "Scenario XXX") { // TODO:
    }
  }
  
  func shareOperatorTransform() {
    
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
