//
//  ContentView.swift
//  UnitConversions
//
//  Created by Farhad Bagherzadeh on 31/10/2022.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel: ContentViewModel = .init()
  @FocusState var isValueFocused: Bool

  var body: some View {
    NavigationView {
      Form {
        Section {
          unitPickerView
          inputUnitPickerView
          outputUnitPickerView
          valueTextFieldView
        } header: {
          Text("Inputs")
        }

        Section {
          Text(viewModel.convertedValue)
        } header: {
          Text("Result")
        }
      }
      .navigationTitle("Unit Conversions")
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("Done") {
            isValueFocused = false
          }
        }
      }
    }
  }
}

private extension ContentView {
  var unitPickerView: some View {
    Picker("", selection: $viewModel.selectedUnit) {
      ForEach(UnitType.allCases, id: \.self) {
        Text("\($0.title)")
      }
    }
    .pickerStyle(.segmented)
  }

  var inputUnitPickerView: some View {
    Picker("Input unit", selection: $viewModel.selectedInputUnit) {
      ForEach(viewModel.inputOutputValues, id: \.self) {
        Text("\($0.rawValue.capitalized)")
      }
    }
    .pickerStyle(.menu)
    .onChange(of: viewModel.selectedInputUnit) { _ in viewModel.convertValue() }
  }

  var outputUnitPickerView: some View {
    Picker("Output unit", selection: $viewModel.selectedOutputUnit) {
      ForEach(viewModel.inputOutputValues, id: \.self) {
        Text("\($0.rawValue.capitalized)")
      }
    }
    .pickerStyle(.menu)
    .onChange(of: viewModel.selectedOutputUnit) { _ in viewModel.convertValue() }
  }

  var valueTextFieldView: some View {
    TextField("Enter value", text: $viewModel.value)
      .keyboardType(.decimalPad)
      .focused($isValueFocused)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
