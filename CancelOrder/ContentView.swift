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
    
    var body: some View {
        NavigationView {
            VStack {
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
            
                VStack (alignment: .leading, spacing: 16){
                    OptionToggle(isSelected: $selectedOption, optionIndex: 0, label: "Не подходит дата получения")
                    OptionToggle(isSelected: $selectedOption, optionIndex: 1, label: "Часть товаров из заказа была отменена")
                    OptionToggle(isSelected: $selectedOption, optionIndex: 2, label: "Не получилось применить скидку или промокод")
                    OptionToggle(isSelected: $selectedOption, optionIndex: 3, label: "Хочу изменить заказ и оформить заново")
                    OptionToggle(isSelected: $selectedOption, optionIndex: 4, label: "Нашелся товар дешевле")
                    OptionToggle(isSelected: $selectedOption, optionIndex: 5, label: "Другое")
                }
                .padding()
                
                TextField("Опишите проблему", text: $text)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(Color(r: 246, g: 246, b: 246))
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                
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
                
                CustomButton(title: "Отменить заказ", backgroundColor: Color(r: 255, g: 70, b: 17))
                {
                    print("1")
                }
                .padding(.top, 15)
            }
            .padding()
            .offset(x: 0, y: -50)
            .navigationTitle("Укажите причину отмены")
            .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    ContentView()
}
