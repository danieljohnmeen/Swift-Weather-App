//
//  LocationForecastViewController.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 02.01.2023.
//

import UIKit
import Combine

final class LocationForecastViewController: BaseViewController, ViewModelable {
    
    typealias ViewModel = LocationForecastViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            viewModel.weatherRecievedPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isRecieved in
                    self?.updateInterface(isRecievedWeather: isRecieved)
                }
                .store(in: &cancellables)
            
            viewModel.getWeatherForecast()
        }
    }
    
    private var forecastViewTopConsatraint: NSLayoutConstraint!
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var forecastView = ForecastView()
    
    private lazy var addButton = UIBarButtonItem(
        title: "Add",
        style: .done,
        target: self,
        action: #selector(addButtonTapped)
    )
    
    private lazy var cancelButton = UIBarButtonItem(
        title: "Cancel",
        style: .plain,
        target: self,
        action: #selector(cancelButtonTapped)
    )
    
    //MARK: - View Controller Lyfecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.moduleWillDisappear()
    }
    
    //MARK: - Methods
    
    override func configureAppearance() {
        super.configureAppearance()
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func setupViews() {
        forecastView.alpha = 0
        view.addSubview(forecastView, useAutoLayout: true)
    }
    
    override func constraintViews() {
        forecastViewTopConsatraint = forecastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.width * 0.7)
        
        NSLayoutConstraint.activate([
            forecastViewTopConsatraint,
            forecastView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            forecastView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            forecastView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Actions

@objc private extension LocationForecastViewController {
    func addButtonTapped() {
        
    }
    
    func cancelButtonTapped() {
        viewModel.dismissPage()
    }
}

//MARK: - Private methods

private extension LocationForecastViewController {
    func updateInterface(isRecievedWeather: Bool) {
        if isRecievedWeather {
            forecastView.viewModel = viewModel.viewModelForWeatherForecastView()
            animateViewAttachmentToTopWithAppearance(
                forecastView,
                topConstraint: forecastViewTopConsatraint
            )
        } else {
            forecastView.alpha = 0
        }
    }
}
