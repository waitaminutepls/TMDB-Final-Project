import Foundation
import RealmSwift

// MARK: - WatchLaterViewModelDelegate

protocol WatchLaterViewModelDelegate: AnyObject {
    func didUpdateWatchLaterItems()
}

// MARK: - WatchLaterViewModel

class WatchLaterViewModel {
    
    var watchLaterItems: Results<WatchLaterItem>?
    private var notificationToken: NotificationToken?
    weak var delegate: WatchLaterViewModelDelegate?
    
    // MARK: - Methods
    
    public func observeRealmChanges() {
        guard let realm = try? Realm() else { return }
        
        watchLaterItems = realm.objects(WatchLaterItem.self)
        delegate?.didUpdateWatchLaterItems()
        notificationToken = watchLaterItems?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial, .update:
                self.delegate?.didUpdateWatchLaterItems()
            case .error(let error):
                print("Failed to observe Realm changes: \(error.localizedDescription)")
            }
        }
    }
    
    public func getWatchLaterItem(at index: Int) -> WatchLaterItem? {
        return watchLaterItems?[index]
    }
    
    public func numberOfWatchLaterItems() -> Int {
        return watchLaterItems?.count ?? 0
    }
    
    private func notifyUpdateWatchLaterItems() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WatchLaterItemsUpdated"), object: nil)
    }
    
    public func deleteWatchLaterItem(at index: Int) {
        guard let itemToDelete = watchLaterItems?[index] else { return }
        RealmManager.shared.deleteWatchLaterItem(item: itemToDelete)
        notifyUpdateWatchLaterItems()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
