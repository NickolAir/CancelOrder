import SwiftUI

extension Color {
    init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha))
    }
}

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}

struct ContentView: View {
    @State private var selectedOption: Int? = nil
    @State private var text: String = ""
    @State private var isCancelButtonPressed: Bool = false
    @State private var isLoading: Bool = false
    @State private var showToast: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if isCancelButtonPressed && selectedOption == nil {
                        HStack {
                            Text("Пожалуйста, выберите причину")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color(r: 244, g: 45, b: 45))
                            
                            Image("redCircle")
                                .padding(.trailing, 14)
                        }
                        .background(Color(r: 255, g: 236, b: 236))
                        .cornerRadius(12)
                        .padding(.top, 15)
                        .transition(.opacity)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        OptionToggle(isSelected: $selectedOption, optionIndex: 0, label: "Не подходит дата получения")
                        OptionToggle(isSelected: $selectedOption, optionIndex: 1, label: "Часть товаров из заказа была отменена")
                        OptionToggle(isSelected: $selectedOption, optionIndex: 2, label: "Не получилось применить скидку или промокод")
                        OptionToggle(isSelected: $selectedOption, optionIndex: 3, label: "Хочу изменить заказ и оформить заново")
                        OptionToggle(isSelected: $selectedOption, optionIndex: 4, label: "Нашелся товар дешевле")
                        OptionToggle(isSelected: $selectedOption, optionIndex: 5, label: "Другое")
                    }
                    .padding(.init(top: 15, leading: 15, bottom: 0, trailing: 15))
                    
                    if selectedOption == 5 {
                        TextField("Опишите проблему", text: $text)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background(Color(r: 246, g: 246, b: 246))
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .transition(.opacity)
                            .padding(.top, 15)
                    }

                    HStack {
                        Text("Обычно деньги сразу возвращаются на карту. В некоторых случаях это может занять до 3 рабочих дней.")
                            .padding(.all, 15)
                        
                        Image("yellowCircle")
                            .padding(.trailing, 14)
                            .offset(x: 0, y: -20)
                    }
                    .background(Color(r: 254, g: 247, b: 222))
                    .cornerRadius(12)
                    .padding(.top, 15)
                    
                    CustomButton(title: "Отменить заказ", backgroundColor: Color(r: 255, g: 70, b: 17)) {
                        if let _ = selectedOption {
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isLoading = false
                                showToast = true
                                selectedOption = nil
                            }
                        } else {
                            isCancelButtonPressed = true
                        }
                    }
                    .padding(.top, 15)
                }
                .padding()
                .offset(x: 0, y: -90)
                .navigationTitle("Укажите причину отмены")
                .navigationBarTitleDisplayMode(.inline)
                
                if isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
            }
            .toast(isPresented: $showToast, message: "Заказ успешно отменён!")
        }
    }
}

struct OptionToggle: View {
    @Binding var isSelected: Int?
    var optionIndex: Int
    var label: String
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { isSelected == optionIndex },
            set: { newValue in
                if newValue {
                    isSelected = optionIndex
                } else {
                    isSelected = nil
                }
            }
        )) {
            Text(label)
                
        }
        .toggleStyle(CheckboxToggleStyle())
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(configuration.isOn ? Color(r: 255, g: 70, b: 17) : Color.gray)
                .background(configuration.isOn ? Color(r: 255, g: 70, b: 17).opacity(0.2) : Color.clear)
                .cornerRadius(5)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.body)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isPresented.wrappedValue = false
                            }
                        }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
