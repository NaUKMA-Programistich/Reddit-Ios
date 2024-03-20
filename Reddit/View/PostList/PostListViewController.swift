import Foundation
import Combine
import UIKit

class PostListViewController: UIViewController {
    enum Constants: String {
        case PostRowId = "postRowId"
    }

    // MARK: Views
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
        }
    }

    // MARK: ViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let postsViewModel = PostListViewModel.share

    // MARK: Data
    private var postsData: [RedditPost] = []
    private var selectedPost: RedditPost?

    // MARK: Configuration
    override func viewDidLoad() {
        super.viewDidLoad()


        postsViewModel.$state.sink { [weak self] state in
            switch(state) {
            case .isLoading:
                self?.setupLoadingView()
                break
            case .succesfull(let posts, let title, let filter, let search):
                let searchPosts = posts.filter { $0.title.starts(with: search)}
                self?.setupPostsView(posts: searchPosts, title: title, filter: filter)
                break
            }
        }.store(in: &subscriptions)
    }

    // MARK: States
    private func setupLoadingView() {
        loadingView.isHidden = false
        searchField.isHidden = true

        navigationItem.title = "Loading"
        navigationItem.rightBarButtonItem = loadingIcon()
    }

    private func loadingIcon() -> UIBarButtonItem {
        let buttonIcon = UIImage(systemName: "arrow.down.doc.fill")
        let barButton = UIBarButtonItem(title: "Loading", style: UIBarButtonItem.Style.done, target: self, action: nil)
        barButton.image = buttonIcon
        barButton.tintColor = .systemYellow
        return barButton
    }


    private func setupPostsView(posts: [RedditPost], title: String, filter: PostFliterState) {
        navigationItem.titleView = nil
        navigationItem.title = title
        navigationItem.rightBarButtonItem = filterBookmarkButton(filter: filter)

        if filter == .all {
            postsData = posts
        } else {
            postsData = posts.filter { $0.isSaved }
        }

        tableView.reloadData()
        loadingView.isHidden = true

        if filter == .all {
            searchField.isHidden = true
            var frameRect = searchField.frame;
            frameRect.size.height = 0;
            searchField.frame = frameRect;
        }
        else {
            searchField.isHidden = false
            var frameRect = searchField.frame;
            frameRect.size.height = 35;
            searchField.frame = frameRect;
        }
    }

    private func filterBookmarkButton(filter: PostFliterState) -> UIBarButtonItem {
        let image = filter.getImage()
        let buttonIcon = UIImage(systemName: image)
        let barButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: #selector(onFilterSave))
        barButton.image = buttonIcon
        barButton.tintColor = .systemYellow
        return barButton
    }

    @objc private func onFilterSave() {
        self.postsViewModel.processFilterSave()
    }

}

// MARK: Table View
extension PostListViewController: UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostListViewController.Constants.PostRowId.rawValue, for: indexPath) as! PostTableViewCell
        let post = postsData[indexPath.row]
        cell.configure(post: post)
        cell.postView.shareDelegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPost = self.postsData[indexPath.row]
        self.performSegue(withIdentifier: PostDetailsViewController.Constants.seque.rawValue, sender: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let height = scrollView.bounds.height

        let part = offset / height

        if part > 0.8 {
            self.postsViewModel.processNextPosts()
        }
    }
}

extension PostListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        self.postsViewModel.processSearch(text: searchText)
    }
}


// MARK: Navigation
extension PostListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == PostDetailsViewController.Constants.seque.rawValue,
            let nextVC = (segue.destination as? PostDetailsViewController),
            let currentPost = self.selectedPost
        else { return }

        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
        DispatchQueue.main.async {
            nextVC.config(post: currentPost)
        }
    }
}
