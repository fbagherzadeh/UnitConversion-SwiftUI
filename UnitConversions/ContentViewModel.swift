//
//  ContentViewModel.swift
//  UnitConversions
//
//  Created by Farhad Bagherzadeh on 1/11/2022.
//

import Combine
import Foundation

enum UnitType: CaseIterable {
  case temperature, length, time, volume

  var title: String {
    switch self {
    case .temperature:
      return "Temp"
    case .length:
      return "Length"
    case .time:
      return "Time"
    case .volume:
      return "Volume"
    }
  }

  var defaultInput: InputOutputType {
    switch self {
    case .temperature:
      return .celsius
    case .length:
      return .meters
    case .time:
      return .seconds
    case .volume:
      return .milliliters
    }
  }

  var defaultOutput: InputOutputType {
    switch self {
    case .temperature:
      return .fahrenheit
    case .length:
      return .kilometers
    case .time:
      return .minutes
    case .volume:
      return .liters
    }
  }
}

enum InputOutputType: String {
  case celsius, fahrenheit, kelvin, meters, kilometers, feet, yards, miles, seconds, minutes, hours, days, milliliters, liters, cups, pints, gallons

  static func getInputOutputValues(for unit: UnitType) -> [InputOutputType] {
    switch unit {
    case .temperature:
      return [.celsius, .fahrenheit, .kelvin]
    case .length:
      return [.meters, .kilometers, .feet, .yards, .miles]
    case .time:
      return [.seconds, .minutes, .hours, .days]
    case .volume:
      return [.milliliters, .liters, .cups, .pints, .gallons]
    }
  }
}

class ContentViewModel: ObservableObject {
  @Published var selectedUnit: UnitType = .temperature
  @Published var selectedInputUnit: InputOutputType = .celsius
  @Published var selectedOutputUnit: InputOutputType = .fahrenheit
  @Published var value: String = ""
  @Published private(set) var convertedValue: String = "N/A"

  var inputOutputValues: [InputOutputType] {
    InputOutputType.getInputOutputValues(for: selectedUnit)
  }

  private var cancellable: Set<AnyCancellable> = .init()

  init() {
    $selectedUnit
      .sink { [weak self] in
        guard let self = self else { return }
        self.value = ""
        self.convertedValue = "N/A"
        self.selectedInputUnit = $0.defaultInput
        self.selectedOutputUnit = $0.defaultOutput
      }
      .store(in: &cancellable)

    $value
      .sink { [weak self] _ in
        self?.convertValue()
      }
      .store(in: &cancellable)
  }

  func convertValue() {
    guard let value = Double(value) else {
      convertedValue = "N/A"
      return
    }

    switch selectedUnit {
    case .temperature, .length, .volume:
      convertedValue = "\(convertMeasurement(value: value) ?? "N/A")"
    case .time:
      convertedValue = "\(convertTime(value: value) ?? "N/A")"
    }

  }

  private func convertMeasurement(value: Double) -> String? {
    var dimension: Dimension?

    switch selectedInputUnit {
    case .celsius:
      dimension = UnitTemperature.celsius
    case .fahrenheit:
      dimension = UnitTemperature.fahrenheit
    case .kelvin:
      dimension = UnitTemperature.kelvin
    case .meters:
      dimension = UnitLength.meters
    case .kilometers:
      dimension = UnitLength.kilometers
    case .feet:
      dimension = UnitLength.feet
    case .yards:
      dimension = UnitLength.yards
    case .miles:
      dimension = UnitLength.miles
    case .milliliters:
      dimension = UnitVolume.milliliters
    case .liters:
      dimension = UnitVolume.liters
    case .cups:
      dimension = UnitVolume.cups
    case .pints:
      dimension = UnitVolume.pints
    case .gallons:
      dimension = UnitVolume.gallons
    default:
      dimension = nil
    }

    guard let dimension = dimension else { return nil }
    let inputValue = Measurement(value: value, unit: dimension)

    switch selectedOutputUnit {
    case .celsius:
      let convertedValue = inputValue.converted(to: UnitTemperature.celsius).value
      return String(format: "%.2f", convertedValue)
    case .fahrenheit:
      let convertedValue = inputValue.converted(to: UnitTemperature.fahrenheit).value
      return String(format: "%.2f", convertedValue)
    case .kelvin:
      let convertedValue = inputValue.converted(to: UnitTemperature.kelvin).value
      return String(format: "%.2f", convertedValue)
    case .meters:
      let convertedValue = inputValue.converted(to: UnitLength.meters).value
      return String(format: "%.2f", convertedValue)
    case .kilometers:
      let convertedValue = inputValue.converted(to: UnitLength.kilometers).value
      return String(format: "%.2f", convertedValue)
    case .feet:
      let convertedValue = inputValue.converted(to: UnitLength.feet).value
      return String(format: "%.2f", convertedValue)
    case .yards:
      let convertedValue = inputValue.converted(to: UnitLength.yards).value
      return String(format: "%.2f", convertedValue)
    case .miles:
      let convertedValue = inputValue.converted(to: UnitLength.miles).value
      return String(format: "%.2f", convertedValue)
    case .milliliters:
      let convertedValue = inputValue.converted(to: UnitVolume.milliliters).value
      return String(format: "%.2f", convertedValue)
    case .liters:
      let convertedValue = inputValue.converted(to: UnitVolume.liters).value
      return String(format: "%.2f", convertedValue)
    case .cups:
      let convertedValue = inputValue.converted(to: UnitVolume.cups).value
      return String(format: "%.2f", convertedValue)
    case .pints:
      let convertedValue = inputValue.converted(to: UnitVolume.pints).value
      return String(format: "%.2f", convertedValue)
    case .gallons:
      let convertedValue = inputValue.converted(to: UnitVolume.gallons).value
      return String(format: "%.2f", convertedValue)
    default:
      return nil
    }
  }

  private func convertTime(value: Double) -> String? {
    var valueInSeconds: Double?

    switch selectedInputUnit {
    case .seconds:
      valueInSeconds = value
    case .minutes:
      valueInSeconds = value * 60
    case .hours:
      valueInSeconds = (value * 60) * 60
    case .days:
      valueInSeconds = ((value * 60) * 60) * 24
    default:
      valueInSeconds = nil
    }

    guard let valueInSeconds = valueInSeconds else { return nil }

    switch selectedOutputUnit {
    case .seconds:
      let convertedValue = valueInSeconds
      return String(format: "%.5f", convertedValue)
    case .minutes:
      let convertedValue = valueInSeconds / 60
      return String(format: "%.5f", convertedValue)
    case .hours:
      let convertedValue = (valueInSeconds / 60) / 60
      return String(format: "%.5f", convertedValue)
    case .days:
      let convertedValue = ((value / 60) / 60) / 24
      return String(format: "%.5f", convertedValue)
    default:
      return nil
    }
  }
}
