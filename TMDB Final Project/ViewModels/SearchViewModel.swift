import Foundation
import Alamofire

class SearchViewModel {
    
    // MARK: - Properties
    
    private(set) var searchArray: [SearchResults] = []
    
    // MARK: - Methods
    
    public func updateSearchResults(_ results: [SearchResults]) {
        searchArray = results
    }

    public func fetchSearchFromServer(with searchText: String, completion: @escaping ([SearchResults]) -> Void) {
        guard !searchText.isEmpty else { return }
        let apiKey = "906f4bd102dba0809de8ac6e45137f9a"
        let baseURL = "https://api.themoviedb.org/3/search/multi?"
        let parameters: [String: Any] = ["api_key": apiKey, "query": searchText]
        
        AF.request(baseURL, parameters: parameters).responseDecodable(of: SearchItem.self) { response in
            switch response.result {
            case .success(let searchList):
                let results = searchList.results ?? []
                completion(results)
            case .failure(let error):
                print("Alamofire request failed: \(error)")
                completion([])
            }
        }
    }
}
