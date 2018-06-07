//
//  subject.swift
//  RxSwiftLearnig
//
//  Created by Linda Zhong on 6/7/18.
//  Copyright © 2018 Null. All rights reserved.
//

import Foundation
import RxSwift

extension ViewController {
  func linda_subject() {
    example(of: "Variable") {
      let subject = Variable<String>("111")
      subject.value = "222"
      subject.asObservable()
        .subscribe(
          onNext: { print($0) },
          onError: { print($0) },
          onCompleted: { print("completed!") }
        )
        .disposed(by: bag)
      subject.value = "333"
    }
    
    example(of: "PublishSubject") {
      let subject = PublishSubject<String>()
      subject.onNext("AAA")
      subject.onNext("BBB")
      subject.asObservable()
        .subscribe(
          onNext: { print($0) },
          onError: { print($0) },
          onCompleted: { print("completed!") }
        )
        .disposed(by: bag)
      subject.onNext("CCC")
    }
    
  }
}
