// FetchTestApp.swift

import SwiftUI

@main
struct FetchTestApp: App {
    let dummyCategory = Category(
        idCategory: "1",
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
