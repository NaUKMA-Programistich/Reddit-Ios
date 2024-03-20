import Foundation

enum PostListViewState {
    case isLoading
    case succesfull(posts: [RedditPost], title: String, filter: PostFliterState, search: String)
}

enum PostFliterState {
    case saved
    case all
    case offline

    func getImage() -> String {
        switch self {
        case .saved: return "bookmark.fill"
        case .offline: return "bookmark.fill"
        case .all: return "bookmark.slash.fill"
        }
    }

    func reverse() -> Self {
        switch self {
        case .all: return .saved
        case .saved: return .all
        case .offline: return .offline
        }
    }

}
