// CategoryViewModel.swift

import Foundation

@MainActor class CategoryViewModel: ObservableObject {
    @Published var meals: [CategoryMeal] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let service: MealsServiceable
    
    init(service: MealsServiceable = MealsService()) {
        self.service = service
    }
    
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
