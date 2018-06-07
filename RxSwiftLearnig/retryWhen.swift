//
//  SHARE+retryWhen.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/7/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  
  func __createErrorSignal() -> Observable<Int> {
    return Observable<Int>.create { observer -> Disposable in
      
      DispatchQueue.global().async {
        print("✨Do...")
        observer.onError(MyError.default)
      }
      
      return Disposables.create()
    }
  }
  
  func shareRetryWhen() {
    
    example(of: "shareRetryWhen") {
      
      let maxCount = 2
      
      __createErrorSignal()
        .retryWhen { e in
          e.enumerated().flatMap { (attempt, error) -> Observable<Int> in
            guard attempt < maxCount else { return Observable.error(error) }
            
            print("✨retry after \(attempt + 1) seconds")
            return Observable<Int>.timer( // MARK: 🎃(1) <= Trigger
              Double(attempt + 1),
              scheduler: MainScheduler.instance
            )
          }
        }
        .catchError { error -> Observable<Int> in
          print("✨Catched error: \(error)")
          return Observable.empty()
        }
        .subscribe(
          onNext: { print("Subscribe:next \($0)") },
          onCompleted: { print("Subscribe: - completed") }
        )
        .disposed(by: bagShare)
    }
  }
}
