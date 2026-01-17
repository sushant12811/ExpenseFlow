//
//  AddExpenseView.swift
//  ExpenseTracker-IOS
//
//  Created by Sushant Dhakal on 2025-10-17.
//

import SwiftUI

struct ExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title : String = ""
    @State private var amountInput : String = ""
    @State private var notes : String = ""
    @State private var selectedCategory: Category = .food
    @State private var date : Date = Date()
    @State private var text : String = ""
    @FocusState private var textInputFocus: Bool
    

    let expense : ExpenseModel?
    
    init(expense: ExpenseModel? = nil) {
            self.expense = expense
            _title = State(initialValue: expense?.title ?? "")
        _amountInput = State(initialValue: expense.map { String($0.amount) } ?? "")
            _date = State(initialValue: expense?.date ?? Date())
        _selectedCategory = State(initialValue: expense?.category ?? .food)
        }
    
    var body: some View {
            Form{
                Section("Expense Details"){
                    TextField("Title", text: $title)
                        .focused($textInputFocus)

                    
                    TextField("Amount", text: $amountInput)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 8))
                        .frame(maxWidth: 100)
                        .multilineTextAlignment(.center)
                        .focused($textInputFocus)
                        
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section("Category"){
                    Picker("Category", selection: $selectedCategory){
                        ForEach(Category.allCases, id: \.self){option in
                            HStack {
                            Image(systemName: option.icon)
                            Text(option.rawValue)
                            }
                            .tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section("Optional(Summary)"){
                    TextEditor(text: $text)
                }
            }
            .onTapGesture {
                textInputFocus = false
                
            }
            .navigationTitle( expense == nil ? "Add expenses" : "Update expenses")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        saveExpense()
                   
                        }label:{
                            Text(expense == nil ? "Save" :"Update")
                        }
                        .disabled(amountInput.isEmpty || title.isEmpty || Double(amountInput) ?? 0 <= 0)
                    
                    
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
            
            }
    private func saveExpense() {
        let finalAmount = Double(amountInput) ?? 0.0
          if let expense = expense {
              // Update existing expense
              expense.title = title
              expense.amount = finalAmount
              expense.category = selectedCategory
              expense.date = date
              expense.notes = notes
          } else {
              // Create new expense
              let newExpense = ExpenseModel(
                  title: title,
                  amount: finalAmount,
                  category: selectedCategory,
                  date: date,
                  notes: notes
              )
              modelContext.insert(newExpense)
          }
        do {
               try modelContext.save()
           } catch {
               print("Failed to save: \(error)")
           }
        dismiss()
          
      }
   }

 
  
  
#Preview {
    ExpenseView(expense: ExpenseModel.sampleData[0])
}
