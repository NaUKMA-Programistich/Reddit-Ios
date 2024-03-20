import Foundation


struct RedditPost: Codable, Equatable {
    let id: String
    let author: String
    let created: String
    let subreddit: String
    let domain: String
    let title: String
    let image: String?
    let score: String
    let numComments: String
    var isSaved: Bool
    let after: String
    let link: String
}
