// FetchTestApp.swift

import SwiftUI

@main
struct FetchTestApp: App {
    let dummyCategory = Category(
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
