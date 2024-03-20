import Foundation

struct RedditCommentResponse: Codable {
    let data: RedditCommentDto?
}

struct RedditCommentDto: Codable {
    let children: [RedditDataCommentDto]
    let after: String?
}

struct RedditDataCommentDto: Codable{
    let data: RedditCommentDataDto
}

struct RedditCommentDataDto: Codable {
    let subredditId: String?
    let author: String?
    let body: String?
    let permalink: String?
    let created: Date?
    let score: Int?
    let name: String?
}



extension RedditCommentResponse {
    func toComments() -> [Comment] {
        return self.data?.children.compactMap {
            $0.data.toComment()
        } ?? []
    }
}

extension RedditCommentDataDto {
    func toComment() -> Comment? {
        guard let _ = self.subredditId else { return nil }
        guard let text = self.body else { return nil }
        guard let user = self.author else { return nil }
        guard let url = self.getCommentLink() else { return nil }

        return Comment(
            user: "/u/\(user)",
            time: created ?? Date(),
            rating: score ?? 0,
            text: text,
            url: url,
            after: name
        )
    }

    private func getCommentLink() -> URL? {
        guard let permalink = self.permalink else { return nil }
        return URL(string: "https://www.reddit.com\(permalink)")
    }
}
