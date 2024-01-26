// CategoryViewModel.swift

import Foundation

@MainActor class CategoryViewModel: ObservableObject {
    /// The meals for the selected category
    @Published var meals: [PartialMeal] = []

    /// Whether or not the view is loading
    @Published var isLoading = false

    /// An error that occurs during the request
    @Published var error: Error?

    /// Whether or not to show the alert for the error
    @Published var showAlert: Bool = false
    
    /// The meals service
    private let service: MealsServiceable
    
    init(service: MealsServiceable = MealsService()) {
        self.service = service
    }
    
    /// Fetches meals for a given category and either sets the meals or the error
    /// - Parameter category: The category to fetch meals for
    func fetchMeals(for category: MealCategory) async {
        isLoading = true
        do {
            let response = try await service.fetchMeals(for: category)
            meals = response
        } catch {
            self.error = error
            self.showAlert = true
        }
        isLoading = false
    }
}
