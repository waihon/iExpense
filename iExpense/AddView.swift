//
//  AddView.swift
//  iExpense
//
//  Created by Waihon Yew on 12/06/2021.
//

import SwiftUI

struct AddView: View {
  @State private var name = ""
  @State private var type = "Personal"
  @State private var amount = ""
  
  static let types = ["Business", "Personal"]
  
  @ObservedObject var expenses: Expenses
  
  @Environment(\.presentationMode) var presentationMode
  
  @State private var showingAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  
  var amountColor: Color {
    if let actualAmount = Int(self.amount) {
      if actualAmount >= 100 {
        return .red
      } else if actualAmount >= 10 {
        return .blue
      } else {
        return .green
      }
    }
    return .black
  }

  var body: some View {
    NavigationView {
      Form {
        TextField("Name", text: $name)
        Picker("Type", selection: $type) {
          ForEach(Self.types, id: \.self) {
            Text($0)
          }
        }
        TextField("Amount", text: $amount)
          .keyboardType(.numberPad)
          .foregroundColor(self.amountColor)
      }
      .navigationBarTitle("Add new expense")
      .navigationBarItems(trailing: Button("Save") {
        if let actualAmount = Int(self.amount) {
          let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
          self.expenses.items.append(item)
          self.presentationMode.wrappedValue.dismiss()
        } else {
          alertTitle = "Error"
          alertMessage = "The Amount field should be an integer number."
          showingAlert = true
        }
      })
      .alert(isPresented: $showingAlert) {
        Alert(title: Text(alertTitle),
              message: Text(alertMessage),
              dismissButton: .default(Text("OK")))
      }
    }
  }
}

struct AddView_Previews: PreviewProvider {
  static var previews: some View {
    AddView(expenses: Expenses())
  }
}
