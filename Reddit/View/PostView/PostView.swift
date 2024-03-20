import UIKit
import SDWebImage

class PostView: UIView {
    // MARK: Constants
    enum Constants: String {
        case kCONTENT_XIB_NAME = "PostView"
    }

    // MARK: Views
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var postView: UIView!

    // MARK: Label
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var whenLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: Button
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var votesButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!

    // MARK: Image
    @IBOutlet private weak var postImage: UIImageView!

    // MARK: Actions + Delegates
    private var currentPost: RedditPost!
    weak var shareDelegate: PostShareDelegate!

    // MARK: Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed(Constants.kCONTENT_XIB_NAME.rawValue, owner: self, options: nil)
        contentView.fixInView(self)
    }

    func configure(post: RedditPost) {
        currentPost = post

        // Label
        usernameLabel.text = post.author
        whenLabel.text = post.created
        domainLabel.text = post.domain
        titleLabel.text = post.title

        // Text buttons
        votesButton.setTitle(post.score, for: .normal)
        commentsButton.setTitle(post.numComments, for: .normal)
        shareButton.setTitle("Share", for: .normal)
        shareButton.addTarget(self, action: #selector(onShare), for: .touchUpInside)

        // Save button
        let image = post.isSaved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        bookmarkButton.setImage(image, for: .normal)
        bookmarkButton.addTarget(self, action: #selector(onSave), for: .touchUpInside)

        // Image
        if let imageUrl = post.image {
            postImage.sd_setImage(
                with: URL(string: imageUrl),
                placeholderImage: UIImage(systemName: "icloud.and.arrow.down")
            )
        } else {
            postImage.image = UIImage(
                systemName: "square.and.arrow.up.trianglebadge.exclamationmark"
            )
        }
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(onSaveWithAnimation))
        imageGesture.numberOfTapsRequired = 2
        imageGesture.delaysTouchesBegan = true
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(imageGesture)

    }

    @objc private func onShare() {
        shareDelegate.sharePost(post: currentPost)
    }

    @objc private func onSaveWithAnimation() {
        let react = CGRect(
            x: Double(self.postImage.frame.size.width / 2.0) - SaveAnimationView.width / 2,
            y: Double(self.postImage.frame.size.height / 2.0) - SaveAnimationView.height / 2,
            width: SaveAnimationView.width,
            height: SaveAnimationView.height
        )
        let animatioView = SaveAnimationView(frame: react)
        self.postImage.addSubview(animatioView)

        if !currentPost.isSaved {
            onSave()
        }
    }

    @objc private func onSave() {
        guard var newPost = currentPost else { return }
        newPost.isSaved.toggle()
        currentPost = newPost

        let image = newPost.isSaved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        bookmarkButton.setImage(image, for: .normal)
        PostListViewModel.share.save(post: newPost)
    }

}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

protocol PostShareDelegate: AnyObject {
    func sharePost(post: RedditPost)
}

extension UIViewController: PostShareDelegate {
    func sharePost(post: RedditPost) {
        let items = [URL(string: post.link)!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}

