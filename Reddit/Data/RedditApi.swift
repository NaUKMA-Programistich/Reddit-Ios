import Foundation

class RedditApi {

    static let share = RedditApi()

    func getComment(
            by subreddit: String,
            id: String,
            and after: String,
            limit: Int = 15,
            result: @escaping (Result<RedditCommentResponse, Error>) -> Void
        ) {
            let responseUrl = "https://www.reddit.com/r/\(subreddit)/comments/\(id).json"
            print("Our url: \(responseUrl)")

            guard let url = URL(string: responseUrl) else {
                result(.failure(RedditError.urlError))
                return
            }

            URLSession(configuration: .ephemeral).dataTask(with: url) { data, response, error in
                if let error = error {
                    result(.failure(error))
                    return
                }

                guard let data = data else {
                    result(.failure(RedditError.nullDataError))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(Array<RedditCommentResponse>.self, from: data)
                    result(.success(response[1]))
                }
                catch {
                    result(.failure(RedditError.serializationError))
                }
            }.resume()
        }


    func getPosts(
        by subreddit: String,
        and after: String,
        limit: Int = 15,
        result: @escaping (Result<RedditPostResponse, Error>) -> Void
    ) {
        let responseUrl = "https://www.reddit.com/\(subreddit)/top.json?limit=\(limit)&after=\(after)"

        guard let url = URL(string: responseUrl) else {
            result(.failure(RedditError.urlError))
            return
        }

        URLSession(configuration: .ephemeral).dataTask(with: url) { data, response, error in
            if let error = error {
                result(.failure(error))
                return
            }

            guard let data = data else {
                result(.failure(RedditError.nullDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(RedditPostResponse.self, from: data)
                result(.success(response))
            }
            catch {
                result(.failure(RedditError.serializationError))
            }
        }.resume()
    }
}


enum RedditError: Error {
    case urlError
    case nullDataError
    case serializationError
    case mappingError
}
