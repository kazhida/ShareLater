import SwiftUI

struct NoteEditView: View {
    let title: String
    let initialContent: String
    let saveTitle: String
    let onCancel: () -> Void
    let onSave: (String) -> Void

    @State private var content: String
    @FocusState private var isFocused: Bool

    init(
        title: String,
        initialContent: String,
        saveTitle: String,
        onCancel: @escaping () -> Void,
        onSave: @escaping (String) -> Void
    ) {
        self.title = title
        self.initialContent = initialContent
        self.saveTitle = saveTitle
        self.onCancel = onCancel
        self.onSave = onSave
        _content = State(initialValue: initialContent)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("メモ編集")
                .font(.title3)

            TextEditor(text: $content)
                .focused($isFocused)
                .frame(minHeight: 140)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.quaternary, lineWidth: 1)
                )
                .accessibilityLabel("内容")

            HStack(spacing: 8) {
                Button("キャンセル", action: onCancel)
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                Button(saveTitle) {
                    onSave(content)
                }
                .buttonStyle(.borderedProminent)
                .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .frame(maxWidth: .infinity)
            }

            Spacer()
        }
        .padding(16)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(TriAheadsTheme.appBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            isFocused = true
        }
    }
}
