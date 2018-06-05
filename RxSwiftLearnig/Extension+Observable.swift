//
//  Extension.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 5/31/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  func learnCreatingObservables() {
    example(of: "[Create Observable] just, of, from") {
      let one = 1
      let two = 2
      let three = 3
      
      let observable: Observable<Int> = Observable<Int>.just(one)
      let observable2 = Observable<Int>.of(one, two, three)
      let observable3 = Observable<Int>.from([one, two, three])
    }
  }
  
  func learnSubscribe() {
    example(of: "[Subscribe Observable]") {
      let one = 1
      let two = 2
      let three = 3
      
      let observable = Observable<Int>.of(one, two, three)
      observable.subscribe { event in
        print(event)
        
        if let element = event.element {
          print(element)
        }
      }
    }
    
    example(of: "[empty]") { // Practice: Just for immediately terminate
      let observable = Observable<Void>.empty()
      
      observable.subscribe(
        onNext: { element in
          print(element)
      },
        onCompleted: {
          print("completed!")
      })
    }
    
    example(of: "never") {
      let observable = Observable<Any>.never()
      
      observable.subscribe(
        onNext: { element in
          print(element)
      },
        onCompleted: {
          print("Completed")
      })
    }
    
    example(of: "range") {
      let observable = Observable<Int>.range(start: 22, count: 10)
      
      observable
        .subscribe(onNext: { i in
          print(i)
        })
    }
  }
  
  func learnDisposingAndTerminating() {
    example(of: "[dispose] cancel a subscription") {
      let observable = Observable.of("A", "B", "C")
      let subscription = observable.subscribe { print($0) }
      subscription.dispose()
    }
    
    example(of: "[DisposeBag] Much better") {
      let bag = DisposeBag()
      let observable = Observable.of("A", "B", "C")
      observable
        .subscribe { print($0) }
        .disposed(by: bag)
    }
    
    example(of: "create") {
      let bag = DisposeBag()
      
      Observable<String>.create { observer in
        observer.onNext("1")
        observer.onCompleted()
        observer.onNext("?")
        return Disposables.create()
        }
        .subscribe(
          onNext: { print($0) },
          onError: { print($0) },
          onCompleted: { print("Completed") },
          onDisposed: { print("Disposed") }
        )
        .disposed(by: bag)
    }
  }
  
  func learnTraits() {
    example(of: "[Trait - Single(~=Value) Completable(~=Bool)] explicit purpose") {
      
      class TextLoadAPI {
        enum FileReadError: Error {
          case fileNotFound, unreadable, encodingFailed
        }
        
        func loadFile() -> Single<String> {
          return Single.create(subscribe: { single -> Disposable in
            let disposable = Disposables.create()
            
            guard let path = Bundle.main.path(forResource: "RELEASE", ofType: "TXT") else {
              single(.error(FileReadError.fileNotFound))
              return disposable
            }
            
            guard let data = FileManager.default.contents(atPath: path) else {
              single(.error(FileReadError.unreadable))
              return disposable
            }
            
            guard let contents = String(data: data, encoding: .utf8) else {
              single(.error(FileReadError.encodingFailed))
              return disposable
            }
            
            single(.success(contents))
            return disposable
          })
        }
      }
      
      let bag = DisposeBag()
      TextLoadAPI()
        .loadFile()
        .subscribe {
          switch $0 {
          case .success(let string): print(string)
          case .error(let error): print(error)
          }
        }
        .disposed(by: bag)
    }
  }
}
