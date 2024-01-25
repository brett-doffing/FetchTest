// MealsService.swift

import Foundation

protocol MealsServiceable{
    func fetchMeals(for category: Category) async throws -> CategoryMealsResponse
    func fetchMeal(with id: String) async throws -> FullMeal?
}

struct MealsService: MealsServiceable {
    /// The base URL for the API
    private let baseURL = "https://themealdb.com"

    /// Fetches meals for a given category
    /// - Parameter category: The category to fetch meals for
    /// - Throws: An error if the request fails
    /// - Returns: A response containing an array of meals
    func fetchMeals(for category: Category) async throws -> CategoryMealsResponse {
        let url = try url(for: Endpoint.filter, query: category.strCategory)
        let response = try await request(with: url, type: CategoryMealsResponse.self)
        let sortedMeals = response.meals.sorted { $0.strMeal < $1.strMeal }
        return CategoryMealsResponse(meals: sortedMeals)
    }

    /// Fetches a meal for a given id
    /// - Parameter id: The id of the meal to fetch
    /// - Throws: An error if the request fails
    /// - Returns: A meal
    func fetchMeal(with id: String) async throws -> FullMeal? {
        let url = try url(for: Endpoint.lookup, query: id)
        let response = try await request(with: url, type: FullMealsResponse.self)
        return response.meals.first
    }

    /// Performs a network request
    /// - Parameters:
    ///   - url: The URL to request
    ///   - type: The type to decode the response to
    /// - Throws: An error if the request fails
    /// - Returns: A decoded response
    private func request<T: Decodable>(with url: URL, type: T.Type) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.invalidHTTPURLResponse }
            if !(response.statusCode >= 200 && response.statusCode < 300) {
                throw NetworkError.invalidStatusCode(statusCode: response.statusCode)
            }

            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.failedToDecode(error: error)
        }
    }

    /// Creates a URL for a given endpoint and query
    /// - Parameters:
    ///   - endpoint: The endpoint to create the URL for
    ///   - query: The query to add to the URL
    /// - Throws: An error if the URL cannot be created
    /// - Returns: A URL
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
}
