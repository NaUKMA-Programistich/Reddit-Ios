import Foundation
import Combine
import Network

private let subreddit = "r/SteamDeck"

class PostListViewModel: ObservableObject {
    static let share = PostListViewModel()

    // MARK: Data
    private let saverDelegate = PostListSaver.share
    private let redditApi = RedditApi.share
    private var after: String = ""

    // MARK: State
    @Published private(set) var state: PostListViewState = .isLoading

    init() {
        processNextPosts()
    }

    func processNextPosts() {
        if !Reachability.isConnectedToNetwork() {
            self.processOfflinePosts()
            return
        }

        redditApi.getPosts(by: subreddit, and: after) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let posts = data.toReddiPosts()
                    self?.processOnlinePosts(posts: posts)
                default:
                    break
                }
            }
        }
    }

    private func processOnlinePosts(posts newPosts: [RedditPost]) {
        // Process after params
        let after = newPosts.last?.after
        if self.after == after { return }
        guard let after = after else { return }
        self.after = after

        switch self.state {
        case .succesfull(let posts, let title, let filter, let search):
            let mergedPost = mergeOfflineAndOnlinePost(onlinePosts: posts + newPosts)
            self.state = .succesfull(posts: mergedPost, title: title, filter: filter, search: search)
            break
        default:
            let mergedPost = mergeOfflineAndOnlinePost(onlinePosts: newPosts)
            self.state = .succesfull(posts: mergedPost, title: subreddit, filter: .all, search: "")
        }
    }

    private func processOfflinePosts() {
        let posts = saverDelegate.getOfflinePosts()
        self.state = .succesfull(posts: posts, title: subreddit, filter: .offline, search: "")
    }

    func processFilterSave() {
        guard case let .succesfull(posts, title, filter, search) = self.state else { return }
        guard filter != .offline else { return }
        self.state = .succesfull(posts: posts, title: title, filter: filter.reverse(), search: search)
    }

    func save(post: RedditPost) {
        guard case let .succesfull(posts, title, filter, search) = self.state else { return }

        let newPosts = posts.map {
            if $0.id == post.id { return post }
            return $0
        }
        self.state = .succesfull(posts: newPosts, title: title, filter: filter, search: search)
    }

    func processSearch(text: String) {
        guard case let .succesfull(posts, title, filter, _) = self.state else { return }
        self.state = .succesfull(posts: posts, title: title, filter: filter, search: text)
    }

    private func mergeOfflineAndOnlinePost(onlinePosts: [RedditPost]) -> [RedditPost] {
        var offlinePosts = saverDelegate.getOfflinePosts()

        return onlinePosts.map { onlinePost in
            let offlinePostById = offlinePosts.first { $0.id == onlinePost.id }

            guard let offlinePost = offlinePostById else {
                return onlinePost
            }
            if let index = offlinePosts.firstIndex(of: offlinePost) {
                offlinePosts.remove(at: index)
            }

            var newPost = onlinePost
            newPost.isSaved = offlinePost.isSaved

            return newPost
        } + offlinePosts
    }
}
