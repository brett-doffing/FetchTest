// CategoryViewModelTests.swift

import XCTest
@testable import FetchTest

class CategoryViewModelTests: XCTestCase {

    var sut: CategoryViewModel!
    var mealsServiceMock: MealsServiceMock!

    @MainActor
    override func setUpWithError() throws {
        try super.setUpWithError()
        mealsServiceMock = MealsServiceMock()
        sut = CategoryViewModel(service: mealsServiceMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        mealsServiceMock = nil
        try super.tearDownWithError()
    }

    @MainActor
    func testFetchMealsSuccess() async throws {
        let category = MealCategory(
            idCategory: "",
            strCategory: "Dessert",
            strCategoryThumb: "",
            strCategoryDescription: ""
        )
        guard let meals = mealsServiceMock.partialMeals() else { throw NSError() }
        mealsServiceMock.fetchMealsResult = .success(meals)

        await sut.fetchMeals(for: category)

        XCTAssertTrue(!sut.meals.isEmpty, "Meal should be empty after failed fetch")
        XCTAssertNil(sut.error, "Error should be nil after successful fetch")
    }

    @MainActor
    func testFetchMealsFailure() async throws {
        let category = MealCategory(
            idCategory: "",
            strCategory: "Dessert",
            strCategoryThumb: "",
            strCategoryDescription: ""
        )
        mealsServiceMock.fetchMealsResult = .failure(NetworkError.invalidURL)

        await sut.fetchMeals(for: category)

        XCTAssertTrue(sut.meals.isEmpty, "Meal should be empty after failed fetch")
        XCTAssertNotNil(sut.error, "Error should not be nil after failed fetch")
    }
}
