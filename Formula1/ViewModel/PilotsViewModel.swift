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
    let pilots: PublishSubject<[PilotModel]> = PublishSubject()
    let disposeBag = DisposeBag()
    
    func fetchData(apiRouterCase: ApiRouter) {
        ApiClient.request(apiRouterCase) { (response: Result<MRData, ApiError>) in
            switch response {
            case .success(let data):
                var newPilots = [PilotModel]()
                for i in 0..<data.MRData.RaceTable.Races.count {
                    newPilots.append(contentsOf: data.MRData.RaceTable.Races[i].getPilotsDataModel())
                }
          
                self.pilots.onNext(newPilots)
                self.pilots.onCompleted()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
