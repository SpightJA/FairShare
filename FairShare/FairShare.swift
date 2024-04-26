//
//  ContentView.swift
//  FairShare
//
//  Created by Jon Spight on 4/10/24.
//

import SwiftUI

struct FairShare: View {
    @State private var checkAmount              = 0.0
    @State private var numberOfPeople           = 2
    @State private var tipPercentage            = 20
    let tipPercentages                          = [10, 15, 20, 25, 0,]
    @State private var noTip                    = true
    @FocusState private var amountIsFocused: Bool
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
            
            ZStack {
                backgroundView()
                Form{
                    DetailsView(checkAmount: $checkAmount,
                                numberOfPeople: $numberOfPeople,
                                isFocused: $amountIsFocused)
                    TipOptionsView(tip: $tipPercentage, tipPercentages: tipPercentages)
                    AmountView(total: grandTotal, tip: tipPercentage)
                    SplitView(perPerson: totalPerPerson)
                }
                .scrollContentBackground(.hidden)
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
}

#Preview {
    FairShare()
}

struct TipOptionsView: View {
    @Binding var tip : Int
    var tipPercentages : [Int]
    var body: some View {
        Section(header: Text("How much do you want to tip").foregroundStyle(.accent)){
            Picker("Tip Percentage", selection: $tip) {
                ForEach(tipPercentages, id: \.self){
                    Text($0, format: .percent)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct AmountView: View {
    var total : Double
    var tip : Int
    var body: some View {
        Section(header: Text("Check Amount").foregroundStyle(.accent)){
            Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundStyle(tip == 0 ? .red : .primary)
        }
    }
}

struct SplitView: View {
    var perPerson : Double
    var body: some View {
        Section(header: Text("Amount per person").foregroundStyle(.accent)){
            Text(perPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}

struct DetailsView: View {
    @Binding var checkAmount : Double
    @Binding var numberOfPeople : Int
    var isFocused : FocusState<Bool>.Binding
    
    var body: some View {
        Section{
            TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .focused(isFocused)
                .keyboardType(.decimalPad)
            
            Picker("Number of people", selection: $numberOfPeople) {
                ForEach(2..<100){
                    Text("\($0) people")
                }
            }
        }
    }
}

struct backgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.bg.opacity(0.8), .bg.opacity(0.1)]), startPoint: .topTrailing, endPoint: .bottomLeading)
        
            .ignoresSafeArea()
    }
}
