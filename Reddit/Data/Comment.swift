import Foundation

struct Comment: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    let user: String
    let time: Date
    let rating: Int
    let text: String
    let url: URL
    let after: String?

    var timeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self.time, relativeTo: Date())
    }

    var ratingString: String {
        return "Rating: \(rating)"
    }

    static let mock = Comment(user: "dadq", time: .now, rating: 12, text: "dad", url: URL(string: "dad")!, after: "dadad")
}
