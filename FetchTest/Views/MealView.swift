// MealView.swift

import SwiftUI

struct MealView: View {
    @StateObject var viewModel = MealViewModel()
    let mealId: String

    var body: some View {
        mealView
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMeal(with: mealId)
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

    /// Creates a view for the meal
    private var mealView: some View {
        ScrollView {
            if let meal = viewModel.meal {
                banner(for: meal.strMealThumb)
                VStack(alignment: .leading) {
                    Text(meal.strMeal)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    instructions(text: meal.strInstructions)
                    ingredients(meal: meal)
                }
                .padding()
            }
        }
    }

    /// Creates a banner for a given image URL or returns an empty view
    private func banner(for imageURL: String) -> some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: Constants.maxHeight)
                .clipped()
        } placeholder: {
            EmptyView()
        }
    }

    /// Creates a view for the instructions
    private func instructions(text: String) -> some View {
        VStack(alignment: .leading) {
            Text("Instructions:")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Text(text)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: Constants.twenty)
                        .stroke()
                }
        }

    }

    /// Creates a view for the ingredients
    private func ingredients(meal: FullMeal) -> some View {
        VStack(alignment: .leading) {
            Text("Ingredients:")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .padding(.vertical)
            ForEach(0..<meal.ingredients.count, id: \.self) { i in
                HStack {
                    Text(meal.ingredients[i])
                    Spacer()
                    Text(meal.measurements[i])
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: Constants.ten)
                    .stroke()
            }
        }
    }

    private struct Constants {
        static let alertButtonTitle = "OK"
        static let alertTitle = "Error"
        static let alertDefaultDescription = "Apologies, but something went wrong."
        static let maxHeight: CGFloat = 200
        static let ten: CGFloat = 10
        static let twenty: CGFloat = 20
        static let scaleSize: CGFloat = 2
    }
}
