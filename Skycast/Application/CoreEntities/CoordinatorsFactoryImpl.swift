//
//  CoordinatorsFactoryImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import Foundation

final class CoordinatorsFactoryImpl: CoordinatorsFactory {

    //MARK: Properties
    
    private let assemblyBuilder: AssemblyBuilder
    
    //MARK: - Initialization
    
    init(assemblyBuilder: AssemblyBuilder) {
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    func createApplicationCoordinator(router: Router) -> ApplicationCoordinator {
        return ApplicationCoordinator(assemblyBuilder: assemblyBuilder, coordinatorsFactory: self, router: router)
    }
    
    func createForecastCoordinator(router: Router) -> ForecastCoordinator {
        return ForecastCoordinator(assemblyBuilder: assemblyBuilder, coordinatorsFactory: self, router: router)
    }

    func createMyLocationsCoordinator(router: Router) -> MyLocationsCoordinator {
        return MyLocationsCoordinator(assemblyBuilder: assemblyBuilder, coordinatorsFactory: self, router: router)
    }
}
