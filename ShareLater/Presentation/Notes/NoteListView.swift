import PhotosUI
import SwiftUI

struct NoteListView: View {
    @ObservedObject var viewModel: NotesViewModel

    @AppStorage("wallpaperImageData") private var wallpaperImageData = Data()
    @State private var noteToEdit: Note?
    @State private var noteToDelete: Note?
    @State private var isAddSheetPresented = false
    @State private var selectedWallpaperItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ZStack {
                wallpaperView

                TriAheadsTheme.overlay
                    .ignoresSafeArea()

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.notes) { note in
                                NoteRowView(
                                    note: note,
                                    onEdit: { noteToEdit = note },
                                    onDelete: { noteToDelete = note }
                                )
                                .id(note.id)
                            }

                            Color.clear.frame(height: 72)
                        }
                        .padding(16)
                    }
                    .refreshable {
                        viewModel.refresh()
                        if let firstNote = viewModel.notes.first {
                            proxy.scrollTo(firstNote.id, anchor: .top)
                        }
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isAddSheetPresented = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .frame(width: 56, height: 56)
                                .background(TriAheadsTheme.fab, in: Circle())
                                .foregroundStyle(.black)
                                .shadow(radius: 4, y: 2)
                        }
                        .accessibilityLabel("追加")
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("トリアヘズ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(TriAheadsTheme.appBar, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "triangle.lefthalf.filled")
                        .foregroundStyle(.white)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        PhotosPicker(selection: $selectedWallpaperItem, matching: .images) {
                            Label("壁紙の変更", systemImage: "photo")
                        }

                        NavigationLink {
                            LicensesView()
                        } label: {
                            Label("ライセンス情報", systemImage: "doc.text")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                    .accessibilityLabel("メニュー")
                }
            }
            .sheet(isPresented: $isAddSheetPresented) {
                NavigationStack {
                    NoteEditView(
                        title: "トリアヘズ",
                        initialContent: "",
                        saveTitle: "追加",
                        onCancel: { isAddSheetPresented = false },
                        onSave: { content in
                            viewModel.addNote(content: content)
                            isAddSheetPresented = false
                        }
                    )
                }
            }
            .navigationDestination(item: $noteToEdit) { note in
                NoteEditView(
                    title: "トリアヘズ -編集-",
                    initialContent: note.content,
                    saveTitle: "更新",
                    onCancel: { noteToEdit = nil },
                    onSave: { content in
                        viewModel.update(note: note, content: content)
                        noteToEdit = nil
                    }
                )
            }
            .alert("メモを削除", isPresented: deleteAlertBinding) {
                Button("キャンセル", role: .cancel) {
                    noteToDelete = nil
                }
                Button("OK", role: .destructive) {
                    if let noteToDelete {
                        viewModel.delete(note: noteToDelete)
                    }
                    noteToDelete = nil
                }
            } message: {
                Text("このメモを削除しますか？")
            }
            .alert("エラー", isPresented: errorAlertBinding) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .task(id: selectedWallpaperItem) {
                await loadSelectedWallpaper()
            }
        }
    }

    private var wallpaperView: some View {
        Group {
            if let image = UIImage(data: wallpaperImageData), !wallpaperImageData.isEmpty {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [.white, Color(red: 0.92, green: 0.97, blue: 1.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        }
    }

    private var deleteAlertBinding: Binding<Bool> {
        Binding(
            get: { noteToDelete != nil },
            set: { isPresented in
                if !isPresented {
                    noteToDelete = nil
                }
            }
        )
    }

    private var errorAlertBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = nil
                }
            }
        )
    }

    private func loadSelectedWallpaper() async {
        guard let selectedWallpaperItem else { return }
        guard let data = try? await selectedWallpaperItem.loadTransferable(type: Data.self) else { return }
        wallpaperImageData = data
    }
}
