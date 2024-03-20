import Foundation

struct RedditPostResponse: Codable {
    let data: RedditDataDto
}

struct RedditDataDto: Codable {
    let children: [RedditPostDto]
    let after: String
}

struct RedditPostDto: Codable{
    let data: RedditPostDataDto
}

struct RedditPostDataDto: Codable {
    let author: String
    let created: Date?
    let domain: String
    let subreddit: String

    let title: String

    let preview: RedditPreiviewDto?

    let score: Int
    let numComments: Int?

    let name: String
    let permalink: String
}

struct RedditPreiviewDto: Codable {
    let images: [RedditImageDto]
}

struct RedditImageDto: Codable {
    let source: RedditSourceDto
}

struct RedditSourceDto: Codable {
    let url: String
    let width: Int
    let height: Int
}

extension RedditPostResponse {
    func toReddiPosts() -> [RedditPost] {
        let posts = self.data.children.map { $0.data }
        return posts.enumerated().map { (index, element) in
            return element.toRedditPost(id: index)
        }
    }
}

extension RedditPostDataDto {
    func toRedditPost(id: Int) -> RedditPost {
        return RedditPost(
            id: getId(),
            author: self.author,
            created: self.getLocalizeTime(),
            subreddit: self.subreddit,
            domain: self.domain,
            title: self.title,
            image: getFirstImage(),
            score: String(self.score),
            numComments: String(self.numComments ?? 0),
            isSaved: false,
            after: self.name,
            link: self.getPostLink()
        )
    }

    private func getId() -> String {
        return self.name.replacingOccurrences(of: "t3_", with: "")
    }

    private func getFirstImage() -> String? {
        return self.preview?
            .images
            .first?
            .source
            .url
            .replacingOccurrences(of: "&amp;", with: "&")
    }

    private func getLocalizeTime() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self.created ?? Date(), relativeTo: Date())
    }

    private func getPostLink() -> String {
        return "https://www.reddit.com\(self.permalink)"
    }
}

