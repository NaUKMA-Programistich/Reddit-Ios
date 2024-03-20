import SwiftUI

struct CommentScreen: View {
    let comment: Comment

    var body: some View {
        ScrollView {
            VStack {
                CommentView(comment: comment, isSingleLineText: false)
                ShareLink(item: comment.url) {
                    Text("Share")
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .background(.blue)
                .cornerRadius(10)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

struct CommentScreenPreview: PreviewProvider {
    static var previews: some View {
        CommentScreen(comment: .mock)
    }
}
