//
//  ContentView.swift
//  FairShare
//
//  Created by Jon Spight on 4/10/24.
//

import SwiftUI

struct FairShare: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    var grandTotal : Double {
        let tip = Double(tipPercentage)
        let tipValue = (checkAmount / 100 ) * tip
        return tipValue + checkAmount
        
    }
    var totalPerPerson : Double {
        let totalPeople = Double(numberOfPeople + 2)
        let perPerson = grandTotal/totalPeople
        
        return perPerson
    }

    
    var body: some View {
        NavigationStack {
            Form{
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .focused($amountIsFocused)
                        .keyboardType(.decimalPad)
                        
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                }
                Section("How much do you want to tip"){
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self){
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                }
                Section("Check Amount"){
                    Text(grandTotal, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                Section("Amount per person"){
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
            .navigationTitle("FairShare")
        }
    }
}

#Preview {
    FairShare()
}
