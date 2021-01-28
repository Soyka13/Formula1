//
//  PilotsViewModel.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 20.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

class PilotsViewModel {
    let pilots: BehaviorRelay<[PilotModel]> = BehaviorRelay(value: [])
    let numberOfRounds: BehaviorRelay<ClosedRange<Int>> = BehaviorRelay(value: 0...0)
    
    func fetchData(apiRouterCase: ApiRouter) {
        NetworkService.request(apiRouterCase) { [weak self](response: Result<MRData<RData>, ApiError>) in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                var newPilots = [PilotModel]()
                for i in 0..<data.MRData.RaceTable.Races.count {
                    newPilots.append(contentsOf: data.MRData.RaceTable.Races[i].getPilotsDataModel())
                }
                self.pilots.accept(newPilots)
                
                let total = Int(data.MRData.RaceTable.Races.count)
  
                if total > 1 {
                    self.numberOfRounds.accept(0...total)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
