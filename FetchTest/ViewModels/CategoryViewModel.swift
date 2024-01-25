// CategoryViewModel.swift

import Foundation

@MainActor class CategoryViewModel: ObservableObject {
    /// The meals for the selected category
    @Published var meals: [CategoryMeal] = []

    /// Whether or not the view is loading
    @Published var isLoading = false

    /// An error that occurs during the request
    @Published var error: Error?
    
    /// The meals service
    private let service: MealsServiceable
    
    init(service: MealsServiceable = MealsService()) {
        self.service = service
    }
    
    /// Fetches meals for a given category and either sets the meals or the error
    /// - Parameter category: The category to fetch meals for
    func fetchMeals(for category: Category) async {
        isLoading = true
        do {
            let response = try await service.fetchMeals(for: category)
            meals = response.meals
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
