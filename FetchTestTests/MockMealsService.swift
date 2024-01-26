// MockMealsService.swift

import Foundation
@testable import FetchTest

class MealsServiceMock: MealsServiceable {
    var fetchMealsResult: Result<[PartialMeal], Error> = .success([])
    var fetchMealResult: Result<FullMeal?, Error> = .success(nil)

    func fetchMeals(for category: MealCategory) async throws -> [PartialMeal] {
        switch fetchMealsResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    func fetchMeal(with id: String) async throws -> FullMeal? {
        switch fetchMealResult {
        case .success(let meal):
            return meal
        case .failure(let error):
            throw error
        }
    }

    func fullMeal() -> FullMeal? {
        let response = try? readJSONFile(named: "StubFullMeal", _type: FullMealsResponse.self)
        return response?.meals.first
    }

    func partialMeals() -> [PartialMeal]? {
        let response = try? readJSONFile(named: "StubPartialMeals", _type: PartialMealsResponse.self)
        return response?.meals
    }

    func readJSONFile<T: Decodable>(named name: String, _type: T.Type) throws -> T {
        do {
            guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json") else {
                fatalError("Could not load \(name).json file")
            }
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NSError()
        }
    }
}
