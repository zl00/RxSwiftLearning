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
  
  func linda_observable() {
    
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
    
    example(of: "observable subscribe multi times") {
      let observable = __observableIsCold()
//        .share(replay: 1, scope: SubjectLifetimeScope.forever) // MARK: 🐠
      
      observable
        .subscribe()
        .disposed(by: bag)
      
      observable
        .subscribe()
        .disposed(by: bag)
    }
    
    example(of: "Observable.Traits.Single") {
      func _readText() throws -> String { return "blabla" }
      func _readTextSingle() -> Single<String> {
        
        return Single.create(subscribe: { single -> Disposable in
          // 🐠1 single.2个方法
          single(.success("success"))
          single(.success("success2")) // 🐠2 会打印success2吗？
          return Disposables.create()
        })
      }
      
      // 🐠3 对比 _readTextSingle __observableIsCold的subscribe处。函数意图更为明确
      _ = _readTextSingle()
        .subscribe(
          onSuccess: { data in print("✨✨\(data)✨✨") },
          onError: { error in print("✨✨\(error)✨✨") }
        ).disposed(by: bagShare)
      
//      __observableIsCold()
//        .subscribe(
//          onNext: { _ in },
//          onError: { _ in },
//          onCompleted: {}
//        ).disposed(by: bag)
    }
    
    example(of: "Observable.Traits.Completable") {
      func __isOK() -> Bool { return true }
      func __isOKCompletable(_ flag: Bool) -> Completable {
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
      
      _ = __isOKCompletable(true)
        .subscribe( // 🐠 函数意图明确
          onCompleted: { print("✨✨completed✨✨") },
          onError: { print("✨✨\($0)✨✨") }
        ).disposed(by: bagShare)
      
//      __observableIsCold()
//        .subscribe(
//          onNext: { _ in },
//          onError: { _ in },
//          onCompleted: {}
//        ).disposed(by: bag)
    }
  }
}
