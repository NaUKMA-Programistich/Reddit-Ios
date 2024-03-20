import Foundation

class PostListSaver {
    static let share = PostListSaver()

    func getOfflinePosts() -> [RedditPost] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = readData() else { return [] }
        guard let posts = try? decoder.decode([RedditPost].self, from: data) else { return [] }
        return posts
    }


    func saveOfflinePosts(posts: [RedditPost]) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .secondsSince1970
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(posts) else { return }
        writeData(data: data)
    }

    private func getURL() -> URL {
        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        guard let url = dir?.appendingPathComponent("reddit").appendingPathExtension("txt") else { fatalError("Error on get url for offline") }

        return url
    }

    private func writeData(data: Data) {
        try! data.write(to: getURL(), options: .atomicWrite)
    }

    private func readData() -> Data? {
        return try? Data(contentsOf: getURL())
    }
}
