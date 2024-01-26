// FetchTestApp.swift

import SwiftUI

@main
struct FetchTestApp: App {
    let dummyCategory = MealCategory(
        idCategory: "",
        strCategory: "Dessert",
        strCategoryThumb: "",
        strCategoryDescription: ""
    )

    var body: some Scene {
        WindowGroup {
            CategoryView(category: dummyCategory)
        }
    }
}
