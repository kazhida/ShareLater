//
//  ContentView.swift
//  ShareLater
//
//  Created by Codex on 2026/05/07.
//

import PhotosUI
import SwiftData
import SwiftUI

private enum Route: Hashable {
    case newNote
    case editNote(PersistentIdentifier)
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]

    @State private var path: [Route] = []
    @State private var notePendingDeletion: Note?
    @State private var selectedWallpaperItem: PhotosPickerItem?
    @State private var wallpaperImage: Image?

    private let wallpaperStore = WallpaperStore()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                wallpaperBackground

                NoteList(
                    notes: notes,
                    onEdit: { note in path.append(.editNote(note.persistentModelID)) },
                    onDelete: { notePendingDeletion = $0 }
                )
            }
            .navigationTitle("トリアヘズ")
            .toolbarBackground(Color.triAheadsBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "text.page.badge.magnifyingglass")
                        .foregroundStyle(.white)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        PhotosPicker(
                            selection: $selectedWallpaperItem,
                            matching: .images
                        ) {
                            Label("壁紙の変更", systemImage: "photo")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }

                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }

                ToolbarItem(placement: .bottomBar) {
                    Button {
                        path.append(.newNote)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.weight(.semibold))
                            .frame(width: 56, height: 56)
                            .background(Color.triAheadsFab, in: Circle())
                            .foregroundStyle(.black)
                    }
                    .accessibilityLabel("メモを追加")
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .newNote:
                    EditNoteScreen(note: nil, onSave: saveNewNote)
                case .editNote(let id):
                    if let note = modelContext.model(for: id) as? Note {
                        EditNoteScreen(note: note, onSave: saveExistingNote)
                    } else {
                        MissingNoteScreen()
                    }
                }
            }
            .confirmationDialog(
                "メモを削除",
                isPresented: Binding(
                    get: { notePendingDeletion != nil },
                    set: { if !$0 { notePendingDeletion = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button("削除", role: .destructive) {
                    deletePendingNote()
                }
                Button("キャンセル", role: .cancel) {
                    notePendingDeletion = nil
                }
            } message: {
                Text("このメモを削除しますか？")
            }
            .task {
                wallpaperImage = wallpaperStore.load()
            }
            .task(id: selectedWallpaperItem) {
                await updateWallpaper()
            }
        }
    }

    @ViewBuilder
    private var wallpaperBackground: some View {
        if let wallpaperImage {
            wallpaperImage
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.white.opacity(0.5).ignoresSafeArea())
        } else {
            Color.white.ignoresSafeArea()
        }
    }

    private func saveNewNote(_ content: String) {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }

        let now = Date()
        modelContext.insert(Note(content: trimmedContent, createdAt: now, updatedAt: now))
        path.removeLast()
    }

    private func saveExistingNote(_ content: String) {
        guard case .editNote(let id) = path.last,
              let note = modelContext.model(for: id) as? Note
        else { return }

        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }

        note.content = trimmedContent
        note.updatedAt = Date()
        path.removeLast()
    }

    private func deletePendingNote() {
        guard let notePendingDeletion else { return }

        modelContext.delete(notePendingDeletion)
        self.notePendingDeletion = nil
    }

    private func updateWallpaper() async {
        guard let selectedWallpaperItem,
              let data = try? await selectedWallpaperItem.loadTransferable(type: Data.self)
        else { return }

        wallpaperStore.save(data)
        wallpaperImage = wallpaperStore.image(from: data)
    }
}

private struct NoteList: View {
    let notes: [Note]
    let onEdit: (Note) -> Void
    let onDelete: (Note) -> Void

    var body: some View {
        if notes.isEmpty {
            ContentUnavailableView(
                "メモがありません",
                systemImage: "note.text",
                description: Text("+ ボタンからメモを作成できます")
            )
        } else {
            List {
                ForEach(notes) { note in
                    NoteRow(
                        note: note,
                        onEdit: { onEdit(note) },
                        onDelete: { onDelete(note) }
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

private struct NoteRow: View {
    let note: Note
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Button(action: onEdit) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(note.content)
                        .foregroundStyle(note.agedContentColor)
                        .font(.body)
                        .multilineTextAlignment(.leading)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Created: \(note.createdAt.formatted(date: .numeric, time: .shortened))")
                        Text("Updated: \(note.updatedAt.formatted(date: .numeric, time: .shortened))")
                    }
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.25))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            ShareLink(item: note.content) {
                Image(systemName: "square.and.arrow.up")
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("メモを共有")

            Button(role: .destructive, action: onDelete) {
                Image(systemName: "trash")
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("メモを削除")
        }
        .padding(12)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)
    }
}

private struct EditNoteScreen: View {
    let note: Note?
    let onSave: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @FocusState private var isContentFocused: Bool
    @State private var content: String

    init(note: Note?, onSave: @escaping (String) -> Void) {
        self.note = note
        self.onSave = onSave
        _content = State(initialValue: note?.content ?? "")
    }

    var body: some View {
        Form {
            Section("メモ編集") {
                TextEditor(text: $content)
                    .focused($isContentFocused)
                    .frame(minHeight: 120)
                    .overlay(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("内容")
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                                .allowsHitTesting(false)
                        }
                    }
            }

            Section {
                HStack(spacing: 8) {
                    Button("キャンセル") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    Button(note == nil ? "追加" : "更新") {
                        onSave(content)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("トリアヘズ ー編集ー")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.triAheadsBlue, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task {
            isContentFocused = true
        }
    }
}

private struct MissingNoteScreen: View {
    var body: some View {
        ContentUnavailableView("メモが見つかりません", systemImage: "exclamationmark.triangle")
    }
}

private struct WallpaperStore {
    private var wallpaperURL: URL {
        URL.documentsDirectory.appending(path: "wallpaper.jpg")
    }

    func load() -> Image? {
        guard let data = try? Data(contentsOf: wallpaperURL) else { return nil }
        return image(from: data)
    }

    func save(_ data: Data) {
        try? data.write(to: wallpaperURL, options: [.atomic])
    }

    func image(from data: Data) -> Image? {
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
        #else
        return nil
        #endif
    }
}

private extension Color {
    static let triAheadsBlue = Color(red: 0.26, green: 0.65, blue: 0.96)
    static let triAheadsFab = Color(red: 0.01, green: 0.85, blue: 0.77)
}

#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
