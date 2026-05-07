import SwiftUI

struct LicensesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("ライセンス情報")
                    .font(.title2)
                    .bold()

                Text("TriAheads Android版からShareLater iOS版へ移植した画面です。")

                Text("iOS版は標準フレームワークのSwiftUI、SwiftData、PhotosUIを使用しています。Firebase同期とGoogleログインはiOS用の設定が未導入のため、この移植ではローカル保存として実装しています。")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        }
        .navigationTitle("ライセンス情報")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(TriAheadsTheme.appBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
