import SwiftUI

struct SelectImportance: View {
    @Binding var importance: Importance

    var body: some View {
        Picker("", selection: $importance) {
            Image("down")
                .font(.system(size: 24))
                .tag(Importance.low)
            
            Text("нет")
                .tag(Importance.medium)
            
            Image(systemName: "exclamationmark.2")
                .fontWeight(.bold)
                .foregroundColor(.red)
                .font(.system(size: 24))
                .tag(Importance.high)
        }
        .pickerStyle(.segmented)
    }

}

#Preview {
    SelectImportance(importance: .constant(.medium))
}

