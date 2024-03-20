import Foundation
import Combine

class CommentViewModel: ObservableObject {
    @Published private(set) var comments: [Comment] = []
    private let redditApi: RedditApi = .share
    private var after: String = ""

    func processComments(post: RedditPost) {
        redditApi.getComment(by: post.subreddit, id: post.id, and: after) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let newComments = data.toComments()
                    let currentComments = self?.comments ?? []
                    self?.comments = currentComments + newComments
                    break
                case .failure(let error):
                    print("Error when get comment information: \(error.localizedDescription)")
                    break
                }
            }
        }
    }

    func processNewComments(currentComment: Comment) {
        let currentComments = self.comments
        let currentCommentSize = self.comments.count

        for i in (currentCommentSize - 4)...(currentCommentSize - 1) {
            if i >= 0 && currentComment.id == currentComments[i].id {
                //
            }
        }
    }
}
