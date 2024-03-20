import SwiftUI

struct CommentListScreen: View {
    let post: RedditPost
    let openComment: (Comment) -> Void
    @StateObject private var viewModel = CommentViewModel()

    var body: some View {
        if (viewModel.comments.isEmpty) {
            ProgressView()
                .onAppear {
                    viewModel.processComments(post: post)
                }
        }

        else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.comments) { comment in
                        CommentView(comment: comment, isSingleLineText: true)
                            .foregroundColor(.black)
                            .padding()
                            .onTapGesture {
                                openComment(comment)
//                                let commentController = UIHostingController(rootView: CommentScreen(comment: comment))
//
//                                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//                                guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
//                                rootViewController.navigationController?.present(commentController, animated: true)
                            }
                        Divider()
                    }
                }
            }
        }
    }
}
