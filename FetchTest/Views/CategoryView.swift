// CategoryView.swift

import SwiftUI
import CachedAsyncImage

struct CategoryView: View {
    @StateObject var viewModel = CategoryViewModel()
    var category: MealCategory

    var body: some View {
        NavigationView {
            meals
            .navigationTitle(category.strCategory)
            .task {
                await viewModel.fetchMeals(for: category)
            }
        }
        .overlay {
            if viewModel.isLoading { ProgressView().scaleEffect(Constants.scaleSize) }
        }
        .alert(Constants.alertTitle, isPresented: $viewModel.showAlert) {
            Button(Constants.alertButtonTitle, role: .cancel, action: {
                viewModel.error = nil
            })
        } message: {
            VStack {
                Text($viewModel.error.wrappedValue?.localizedDescription ?? Constants.alertDefaultDescription)
            }
        }
    }

    /// Creates a list of navigation links for the meals
    private var meals: some View {
        List(viewModel.meals, id: \.self) { meal in
            NavigationLink(destination: MealView(mealId: meal.idMeal)) {
                HStack {
                    thumbnail(for: meal.strMealThumb)
                    Text(meal.strMeal)
                }
            }
            .listRowInsets(EdgeInsets(
                top: Constants.zero,
                leading: Constants.zero,
                bottom: Constants.zero,
                trailing: Constants.ten)
            )
        }
    }

    /// Creates a thumbnail for a given image URL
    private func thumbnail(for imageURL: String) -> some View {
        URLImage(url: URL(string: imageURL))
            .scaledToFill()
            .aspectRatio(Constants.aspectRatio, contentMode: .fit)
            .frame(width: Constants.thumbnailDimension, height: Constants.thumbnailDimension)
    }

    private struct Constants {
        static let alertButtonTitle = "OK"
        static let alertTitle = "Error"
        static let alertDefaultDescription = "Apologies, but something went wrong."
        static let thumbnailDimension: CGFloat = 75
        static let aspectRatio: CGFloat = 1
        static let zero: CGFloat = 0
        static let ten: CGFloat = 10
        static let scaleSize: CGFloat = 2
    }
}

