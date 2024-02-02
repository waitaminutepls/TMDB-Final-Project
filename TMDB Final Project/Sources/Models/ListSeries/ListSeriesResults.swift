import Foundation
struct ListSeriesResults : Codable {
	let adult : Bool?
	let backdropPath : String?
	let genreIds : [Int]?
	let id : Int?
	let originCountry : [String]?
	let originalLanguage : String?
	let originalName : String?
	let overview : String?
	let popularity : Double?
	let posterPath : String?
	let firstAirDate : String?
	let name : String?
	let voteAverage : Double?
	let voteCount : Int?

	enum CodingKeys: String, CodingKey {

		case adult = "adult"
		case backdropPath = "backdrop_path"
		case genreIds = "genre_ids"
		case id = "id"
		case originCountry = "origin_country"
		case originalLanguage = "original_language"
		case originalName = "original_name"
		case overview = "overview"
		case popularity = "popularity"
		case posterPath = "poster_path"
		case firstAirDate = "first_air_date"
		case name = "name"
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
        genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        originCountry = try values.decodeIfPresent([String].self, forKey: .originCountry)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        firstAirDate = try values.decodeIfPresent(String.self, forKey: .firstAirDate)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
	}
}
