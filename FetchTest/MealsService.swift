// MealsService.swift

import Foundation

protocol MealsServiceable{
    func fetchMeals(for category: Category) async throws -> CategoryMealsResponse
    func fetchMeal(with id: String) async throws -> FullMeal?
}

struct MealsService: MealsServiceable {
    private let baseURL = "https://themealdb.com"

    /**
    Fetches all meals for a category
    - Parameters:
      - category: The category to fetch meals for
    - Returns: An array of meals
    */
    func fetchMeals(for category: Category) async throws -> CategoryMealsResponse {
        let url = try url(for: Endpoint.filter, query: category.strCategory)
        let response = try await request(with: url, type: CategoryMealsResponse.self)        let sortedMeals = response.meals.sorted { $0.strMeal < $1.strMeal }
        return CategoryMealsResponse(meals: sortedMeals)
    }

    /**
    Fetches a meal with a given id
    - Parameters:
      - id: The id of the meal to fetch
    - Returns: A meal
    - Note: The response returns an array of meals, but we only want one
    */
    func fetchMeal(with id: String) async throws -> FullMeal? {
        let url = try url(for: Endpoint.lookup, query: id)
        let response = try await request(with: url, type: FullMealsResponse.self)
        return response.meals.first
    }

    /**
    Generic request function
    - Parameters:
      - urlString: The URL to request
      - type: The type to decode the response to
    - Returns: The decoded response
    */
    private func request<T: Decodable>(with url: URL, type: T.Type) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.InvalidHTTPURLResponse }
            if !(response.statusCode >= 200 && response.statusCode < 300) {
                throw NetworkError.invalidStatusCode(statusCode: response.statusCode)
            }

            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.failedToDecode(error: error)
        }
    }

    /**
    Creates a URL for a given endpoint and query
    - Parameters:
      - endpoint: The endpoint to create the URL for
      - query: The query to add to the URL
    - Returns: A URL
    */
    private func url(for endpoint: Endpoint, query: String) throws -> URL {
        var components = URLComponents(string: baseURL)
        components?.path = endpoint.path
        let queryItem = URLQueryItem(name: endpoint.queryName, value: query)
        components?.queryItems = [queryItem]

        guard let url = components?.url else { throw NetworkError.invalidURL }
        return url
    }
}

extension MealsService {
    /// The endpoints for the API
    private enum Endpoint: String {
        case filter, lookup

        /// The path for the endpoint
        var path: String {
            return "/api/json/v1/1/\(rawValue).php"
        }

        /// The query parameter name for the endpoint
        var queryName: String {
            switch self {
            case .filter:
                return "c"
            case .lookup:
                return "i"
            }
        }
    }
    
    /// The errors for the API
    enum NetworkError: Error {
        case invalidURL
        case InvalidHTTPURLResponse
        case invalidStatusCode(statusCode: Int)
        case failedToDecode(error: Error)

        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .InvalidHTTPURLResponse:
                return "Invalid HTTPURLResponse"
            case .invalidStatusCode(let statusCode):
                return "Invalid Status Code: \(statusCode)"
            case .failedToDecode(let error):
                return "Failed to Decode: \(error.localizedDescription)"
            }
        }
    }
}
