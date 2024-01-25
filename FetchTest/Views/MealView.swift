// MealView.swift

import SwiftUI

struct MealView: View {
    @StateObject var viewModel = MealViewModel()
    let mealId: String

    var body: some View {
        mealView
            .task {
                await viewModel.fetchMeal(with: mealId)
            }
    }

    private var mealView: some View {
        ScrollView {
            if let meal = viewModel.meal {
                thumbnail(for: meal.strMealThumb)
                VStack(alignment: .leading) {
                    Text(meal.strMeal)
                        .font(.title)
                        .padding(.bottom)
                    Text("Instructions:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(meal.strInstructions)
                        .padding(.top)
                    Text("Ingredients:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.vertical)
                    ForEach(0..<meal.ingredients.count, id: \.self) { i in
                        HStack {
                            Text(meal.ingredients[i])
                            Spacer()
                            Text(meal.measurements[i])
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func thumbnail(for imageURL: String) -> some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 150)
                .clipped()
        } placeholder: {
            EmptyView()
        }
    }
}

//struct MealView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealView()
//    }
//}
