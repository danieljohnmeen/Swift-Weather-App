//
//  CurrentWeatherView.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import UIKit
import Combine

final class CurrentWeatherView: BaseView, ViewModelable {
    
    typealias ViewModel = CurrentWeatherViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            viewModel.iconUpdatePublisher
                .sink { [weak self] dayTime, code in
                    self?.iconManager.setIcon(code: code, dayTime: dayTime)
                }
                .store(in: &cancellables)
            
            viewModel.temperaturePublisher
                .mapToTemperature(in: .celsius)
                .map { $0.stringFormat }
                .assignToTextOnLabel(temperatureLabel)
                .store(in: &cancellables)
            
            viewModel.conditionPublisher
                .assignToTextOnLabel(conditionLabel)
                .store(in: &cancellables)
            
            viewModel.locationPublisher
                .assignToTextOnLabel(locationLabel)
                .store(in: &cancellables)
            
        }
    }
    
    private let iconManager = WeatherIconManager()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var mainVStack = UIStackView(
        axis: .vertical,
        spacing: 20,
        arrangedSubviews: [
            weatherHStack,
            locationHStack
        ]
    )
    
    private lazy var weatherHStack = UIStackView(
        axis: .horizontal,
        spacing: 20,
        arrangedSubviews: [
            labelsVStack,
            weatherIconView
        ]
    )
    
    private lazy var labelsVStack = UIStackView(
        axis: .vertical,
        spacing: 5,
        arrangedSubviews: [
            temperatureLabel,
            conditionLabel
        ]
    )
    
    private lazy var locationHStack =  UIStackView(
        axis: .horizontal,
        spacing: 10,
        alignment: .center,
        arrangedSubviews: [
            locationImageView,
            locationLabel
        ]
    )
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Resources.Strings.currentWeatherTitle
        label.font = Resources.Fonts.system(size: 17, weight: .semibold)
        label.textColor = Resources.Colors.title
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.Fonts.system(size: 40, weight: .bold)
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.Fonts.system(size: 16, weight: .medium)
        label.textColor = Resources.Colors.darkText
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = Resources.Fonts.system(size: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView(image: Resources.Images.location)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    //MARK: - Lyfecycle
    
    override func layoutSubviews() {
        layer.cornerRadius = 20
        addShadow()
    }
    
    //MARK: - Methods
    
    override func configureAppearance() {
        backgroundColor = Resources.Colors.secondaryBackground
        
        iconManager.$icon
            .assign(to: \.image, on: weatherIconView)
            .store(in: &cancellables)
    }
    
    override func setupViews() {
        addSubview(titleLabel, useAutoLayout: true)
        addSubview(mainVStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        weatherIconView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            weatherIconView.widthAnchor.constraint(equalToConstant: 80),
            
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalTo: locationImageView.widthAnchor),
                                    
            mainVStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

//MARK: - Private methods

private extension CurrentWeatherView {
    func addShadow() {
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 7)
    }
}

