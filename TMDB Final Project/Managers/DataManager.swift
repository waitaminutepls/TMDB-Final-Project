import Foundation
import RealmSwift

// MARK: - Properties

class WatchLaterItem: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String? = ""
    @objc dynamic var posterURL: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var isMovie: Bool = true
    
    convenience init(id: Int, title: String, posterURL: String, overview: String, isMovie: Bool) {
        self.init()
        self.id = id
        self.title = title
        self.posterURL = posterURL
        self.overview = overview
        self.isMovie = isMovie
    }
}

// MARK: - Initialization

class RealmManager {
    
    static let shared = RealmManager()
    private var realm: Realm!
    
    public init() {
        setupRealm()
    }
    
    // MARK: - Methods
    
    private func setupRealm() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    public func addWatchLaterItem(addId: Int, addTitle: String?, addPosterURL: String, addOverview: String, addIsMovie: Bool) {
        guard !isAddedToWatchList(with: addId, isMovie: addIsMovie) else { return }
        let item = WatchLaterItem()
        item.id = addId
        item.title = addTitle
        item.posterURL = addPosterURL
        item.overview = addOverview
        item.isMovie = addIsMovie
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Failed to add movie to Realm: \(error.localizedDescription)")
        }
    }
    
    public func deleteWatchLaterItem(item: WatchLaterItem) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Failed to delete movie from Realm: \(error.localizedDescription)")
        }
    }
    
    public func deleteFromWatchList(withItemId itemId: Int) {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: itemId))
        if let item = realm.objects(WatchLaterItem.self).filter(predicate).first {
            deleteWatchLaterItem(item: item)
        }
    }
    
    public func isAddedToWatchList(with itemId: Int, isMovie: Bool) -> Bool {
        let predicate = NSPredicate(format: "id == %@ AND isMovie == %@", NSNumber(value: itemId), NSNumber(value: isMovie))
        let result = realm.objects(WatchLaterItem.self).filter(predicate)
        return !result.isEmpty
    }
}
