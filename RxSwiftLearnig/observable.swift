//
//  observable.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/7/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  
  func linda_cold() {
    
    func __observableIsCold() -> Observable<String> {
      
      return Observable<String>.create { observer -> Disposable in
        
          print("linda_cold handling...")
          observer.onNext("✨observable is cold")
          observer.onCompleted()
          observer.onNext("XXX") // MARK: 🐠next after completed
          
          return Disposables.create()
      }
    }
    
    example(of: "observable is cold") {
      _ = __observableIsCold()
//        .subscribe(
//          onNext: { element in
//            print("received \(element)")
//          },
//          onError: { error in
//            print("received \(error)")
//          },
//          onCompleted: {
//            print("received completed")
//          }
//        )
//        .disposed(by: bag)
    }
    
    example(of: "observable create") {
      Observable.of(1, 2, 3) // Observable.just
        .subscribe(
          onNext: { element in
            print("received \(element)")
          },
          onError: { error in
            print("received \(error)")
          },
          onCompleted: {
            print("received completed")
          }
        )
        .disposed(by: bag)
      
//      Observable<String>.create({ (<#AnyObserver<String>#>) -> Disposable in
//        <#code#>
//      })
    }
    
    example(of: "Observable.Traits.Single") {
      func _readText() throws -> String { return "blabla" }
      func _readTextObservable(_ flag: Bool) -> Single<String> {
        
        return Single.create(subscribe: { single -> Disposable in
          // SingleEvent // 🐠 Observable.Traits - 1: 看一下它的定义
          if flag { single(.success("success")); single(.success("success2")) } // 🐠 Observable.Traits - 3 `single(.success("success2"))` is ignored
          else { single(.error(NSError.init(domain: "error", code: -1, userInfo: nil))) }
          
          return Disposables.create()
        })
      }
      
      // 🐠 Observable.Traits - 2: 敲一下subscribe，发现指定了函数是onSuccess, onError
      _ = _readTextObservable(true)
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
  }
}
