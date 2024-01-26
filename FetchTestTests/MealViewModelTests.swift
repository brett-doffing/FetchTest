// MealViewModelTests.swift

import XCTest
@testable import FetchTest

class MealViewModelTests: XCTestCase {

    var sut: MealViewModel!
    var mealsServiceMock: MealsServiceMock!

    @MainActor
    override func setUpWithError() throws {
        try super.setUpWithError()
        mealsServiceMock = MealsServiceMock()
        sut = MealViewModel(service: mealsServiceMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        mealsServiceMock = nil
        try super.tearDownWithError()
    }

    @MainActor
    func testFetchMealSuccess() async throws {
        let mealId = "53049"
        guard let meal = mealsServiceMock.fullMeal() else { throw NSError() }
        mealsServiceMock.fetchMealResult = .success(meal)

        await sut.fetchMeal(with: mealId)

        XCTAssertNotNil(sut.meal, "Fetched meal should not be nil")
        XCTAssertNil(sut.error, "Error should be nil after successful fetch")
    }

    @MainActor
    func testFetchMealFailure() async throws {
        let mealId = "invalidID"
        mealsServiceMock.fetchMealResult = .failure(NetworkError.invalidURL)

        await sut.fetchMeal(with: mealId)

        XCTAssertNil(sut.meal, "Meal should be nil after failed fetch")
        XCTAssertNotNil(sut.error, "Error should not be nil after failed fetch")
    }
}
