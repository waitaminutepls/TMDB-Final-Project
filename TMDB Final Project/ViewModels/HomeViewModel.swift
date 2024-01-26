import Foundation
import Alamofire

class HomeViewModel {
    
    // MARK: - Properties
    
    var moviesArray: [ListMoviesResults] = []
    var seriesArray: [ListSeriesResults] = []
    
    // MARK: - Methods
    
    public func updateSearchMovieResults(_ results: [ListMoviesResults]) {
        moviesArray = results
    }
    
    public func updateSearchShowResults(_ results: [ListSeriesResults]) {
        seriesArray = results
    }
    
    public func configureMovieHeader() -> ListMoviesResults? {
        return moviesArray.randomElement()
    }
    
    public func configureSeriesHeader() -> ListSeriesResults? {
        return seriesArray.randomElement()
    }
    
    public func fetchMoviesFromServer(completion: @escaping ([ListMoviesResults]) -> Void) {
        let requestURL = "https://api.themoviedb.org/3/movie/popular?api_key=906f4bd102dba0809de8ac6e45137f9a"
        
        AF.request(requestURL).responseDecodable(of: ListMovies.self) { response in
            switch response.result {
            case .success(let listMovies):
                let results = listMovies.results ?? []
                completion(results)
            case .failure(let error):
                print("Alamofire request failed: \(error)")
                completion([])
            }
        }
    }
    
    public func fetchSeriesFromServer(completion: @escaping ([ListSeriesResults]) -> Void) {
        let requestURL = "https://api.themoviedb.org/3/tv/popular?api_key=906f4bd102dba0809de8ac6e45137f9a"
        
        AF.request(requestURL).responseDecodable(of: ListSeries.self) { response in
            switch response.result {
            case .success(let listSeries):
                let results = listSeries.results ?? []
                completion(results)
            case .failure(let error):
                print("Alamofire request failed: \(error)")
                completion([])
            }
        }
    }
}
