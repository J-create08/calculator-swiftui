//
//  ContentView.swift
//  CalculatorSwiftUI
//
//  Created by Juan Carlos  Rojas on 14/3/21.
//

import SwiftUI

enum CalculatorButton: String {
    
    case zero, one, two, three, four, five, six, seven, eight, nine, ten
    case equals, plus, minus, multiply, divide
    case decimal
    case ac, plusMinus, percent
    
    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .equals: return "="
        case .minus: return "-"
        case .plus: return "+"
        case .divide: return "÷"
        case .multiply: return "x"
        case .percent: return "%"
        case .plusMinus: return "±"
        case .decimal: return "."
            
        default:
            return "AC"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal:
            return Color(.darkGray)
        case .ac, .plusMinus, .percent:
            return Color(.lightGray)
        default:
            return Color(.orange)
        }
    }
}

enum Operation {
    case plus, minus, multiply, divide, none
}

// Env object
//Global aplication state
class GlobalEnvironment: ObservableObject {
    
    @Published var display = ""
    var currentOperation: Operation = .none
    var currentValue = 0
    
    
    func recieveInput(calculatorButton: CalculatorButton){
        switch calculatorButton {
        case .ac:
            self.display = ""
        case .plus, .minus, .multiply, .divide, .equals:
            if calculatorButton == .plus {
                self.currentOperation = .plus
                self.currentValue = Int(self.display) ?? 0
            }
            else if calculatorButton == .minus {
                self.currentOperation = .minus
                self.currentValue = Int(self.display) ?? 0
            }
            else if calculatorButton == .multiply {
                self.currentOperation = .multiply
                self.currentValue = Int(self.display) ?? 0
            }
            else if calculatorButton == .divide {
                self.currentOperation = .divide
                self.currentValue = Int(self.display) ?? 0
            }
            else if calculatorButton == .equals {
                let runningValue = self.currentValue
                let currentValue = Int(self.display) ?? 0
                switch self.currentOperation {
                case .plus:
                    self.display = "\(runningValue + currentValue)"
                case .minus:
                    self.display = "\(runningValue - currentValue)"
                case .multiply:
                    self.display = "\(runningValue * currentValue)"
                case .divide:
                    self.display = "\(runningValue / currentValue)"
                case .none:
                    break
                }
                
            }
            if calculatorButton != .equals {
                self.display = ""
            }
        default:
            if self.display == "0"{
                self.display = "0"
            }
            else{
                self.display = "\(self.display)\(calculatorButton.title)"
            }
            
        }
    
    }
    
}

struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment
    
    let buttons: [[ CalculatorButton ]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equals]
    ]
    var body: some View {
        
        ZStack(alignment: .bottom){
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            
            VStack (spacing: 12){
                HStack{
                    Spacer()
                    Text(env.display).foregroundColor(.white)
                        .bold()
                        .font(.system(size: 64))
                }.padding()
                
                ForEach(buttons, id:\.self){ row in
                    HStack (spacing: 12){
                        ForEach(row, id: \.self){ button in
                            calculatorButtonView(button: button)
                        }
                        
                    }
                }
                
            }.padding(.bottom)
        }
       
    }
    
    
}

struct calculatorButtonView: View {
    var button: CalculatorButton
    
    @EnvironmentObject var env: GlobalEnvironment
    var body: some View {
        Button(action: {
            self.env.recieveInput(calculatorButton: self.button)
        }) {
            Text(button.title)
                .font(.system(size: 32))
                .frame(width:self.buttonWidth(button: button), height: (UIScreen.main.bounds.width - 5 * 12) / 4)
                .foregroundColor(.white)
                .background(button.backgroundColor)
                .cornerRadius(self.buttonWidth(button: button))
        }
    }
    private func buttonWidth(button: CalculatorButton) -> CGFloat {
        
        if button == .zero {
            return (UIScreen.main.bounds.width - 2 * 12) / 4 * 2
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}
