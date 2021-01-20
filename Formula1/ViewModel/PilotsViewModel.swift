//
//  DriverViewModel.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 20.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

class PilotsViewModel {
    let pilots: PublishSubject<[Result]> = PublishSubject()
    var raceName: String?
    
    let disposeBag = DisposeBag()
    
    func fetchNewPilots() {
        ApiClient.getPilots()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self](data) in
                    guard let self = self else { return }
//                    print("!!!!!!! Data: \(data)")
                    self.raceName = data.MRData.RaceTable.Races[0].raceName
                    self.pilots.onNext(data.MRData.RaceTable.Races[0].Results)
                    self.pilots.onCompleted()
                },
                onError: { (error) in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
}
