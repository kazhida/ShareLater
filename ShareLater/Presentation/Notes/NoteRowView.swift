import SwiftUI

struct NoteRowView: View {
    let note: Note
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Button(action: onEdit) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(note.content)
                        .font(.body)
                        .foregroundStyle(TriAheadsTheme.agedTextColor(createdAt: note.createdAt))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Created: \(note.createdAt.formatted(date: .numeric, time: .shortened))")
                        Text("Updated: \(note.updatedAt.formatted(date: .numeric, time: .shortened))")
                    }
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.25))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            VStack {
                HStack(spacing: 4) {
                    ShareLink(item: note.content) {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)

                    Button(role: .destructive, action: onDelete) {
                        Image(systemName: "trash")
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(12)
        .background(TriAheadsTheme.surface, in: RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    NoteRowView(
        note: Note(content: "Sample note"),
        onEdit: {},
        onDelete: {}
    )
    .padding()
}
