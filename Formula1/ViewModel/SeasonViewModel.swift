//
//  SeasonViewModel.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 27.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

class SeasonViewModel {
    let seasons: BehaviorRelay<[Season]> = BehaviorRelay(value: [])
    
    func fetchData(apiRouterCase: ApiRouter) {
        NetworkService.request(apiRouterCase) { [weak self](response: Result<MRData<SData>, ApiError>) in
            guard let self = self else { return }
            switch response {
            
            case .success(let data):
                let reversedData = Array(data.MRData.SeasonTable.Seasons.reversed())
                self.seasons.accept(reversedData)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
