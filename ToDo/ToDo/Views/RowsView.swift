import SwiftUI

struct RowsView: View {
    var item: ToDoItem

    var body: some View {
        HStack(spacing: 10) {
            CircleImage()
            if item.importance == .high && !item.isDone {
                ExclamationMarkImage()
            }
            TextView()
            Spacer()
            ChevronImage()
        }
    }

    private func TextView() -> some View {
        VStack(alignment: .leading) {
            if item.isDone {
                Text(item.text)
                    .lineLimit(3)
                    .strikethrough()
                    .font(.system(size: 17))
                    .foregroundStyle(Color("LabelTertiary"))
            } else {
                Text(item.text)
                    .font(.system(size: 17))
                    .foregroundStyle(Color("LabelPrimary"))
                if let deadline = item.deadline {
                    HStack {
                        Image(systemName: "calendar")
                        Text(deadline, style: .date)
                    }
                    .font(.system(size: 15))
                    .foregroundStyle(Color("LabelTertiary"))
                }
            }
        }
    }

    private func CircleImage() -> some View {
        Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
            .resizable()
            .foregroundStyle(item.isDone ? Color.green : item.importance == .high ? Color.red : Color("SupportSeparator"))
            .frame(width: 24, height: 24)
    }

    private func ChevronImage() -> some View {
        Image(systemName: "chevron.right")
            .resizable()
            .foregroundStyle(.gray)
            .frame(width: 7, height: 12)
            .bold()
    }

    private func ExclamationMarkImage() -> some View {
        Image(systemName: "exclamationmark.2")
            .fontWeight(.bold)
            .foregroundColor(.red)
            .font(.system(size: 24))
    }
}

#Preview {
    RowsView(item: DataControlModel().data[0])
        .padding()
}
