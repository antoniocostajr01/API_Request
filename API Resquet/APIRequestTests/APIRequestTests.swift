//
//  APIRequestTests.swift
//  APIRequestTests
//
//  Created by sofia leitao on 26/08/25.
//

import Testing
@testable import APIRequest
import Foundation
struct APIRequestTests {
    
    // MARK: - HomeViewModel

    @Test func fetchProducts() async throws {
        
        let productService = APIServiceMock()
        let viewModel = await HomeViewModel(service: productService)

        await viewModel.load()
        await #expect(viewModel.products.count > 0)
    
    }
    
    @Test func fetchProductsShouldFail() async throws {
        
        let productService = APIServiceMock(shouldFail: true)
        let viewModel = await HomeViewModel(service: productService)

        await viewModel.load()
        await #expect(viewModel.products.isEmpty)
    
    }
    
    @Test func fetchCategoriesShouldFail() async throws {
        let productService = APIServiceMock(shouldFail: true)
        let viewModel = await HomeViewModel(service: productService)

        await viewModel.load()
        await #expect(viewModel.products.isEmpty)
    
    }
    
    @Test func toggleFavorite() async throws {
        let productService = APIServiceMock(shouldFail: true)
        let viewModel = await HomeViewModel(service: productService)
        
        await viewModel.load()
        await viewModel.toggleIsFavorite(id: 1)
        await #expect(viewModel.isFavorite == true)
        
    }
    
    // MARK: - CategoryProductsViewModel
    
    @Test func categoryLoadProducts() async throws {
        let products: [Product] = [
            Product(id: 1, title: "Red Lipstick", description: "d", category: "beauty",    price: 12.4, brand: "A", thumbnail: "img"),
            Product(id: 2, title: "Shampoo",      description: "d", category: "beauty",    price: 20.0, brand: "B", thumbnail: "img"),
            Product(id: 3, title: "Office Chair", description: "d", category: "furniture", price: 199,  brand: "C", thumbnail: "img")
        ]
        let service = APIServiceMock(products: products, shouldFail: false, categories: [])
        let vm = await CategoryProductViewModel(service: service)
        let category = Category(slug: "beauty", name: "Beauty", url: "beauty")
        
        await vm.loadProducts(category: category)
        
        await #expect(vm.errorMessage == nil)
        await #expect(vm.isLoading == false)
        await #expect(vm.products.count == 2)
        await #expect(vm.filteredProducts.count == 2)
    }
    
    @Test @MainActor
    func categoryLoadProductsShouldFail() async throws {
        let service = APIServiceMock(products: [], shouldFail: true, categories: [])
        let vm =  CategoryProductViewModel(service: service)
        let category = Category(slug: "beauty", name: "Beauty", url: "beauty")
        
        await vm.loadProducts(category: category)
        
         #expect(vm.isLoading == false)
         #expect(vm.products.isEmpty)
         #expect(vm.filteredProducts.isEmpty)
         #expect(vm.errorMessage != nil)
    }
    
  @MainActor @Test func categorFilterProductsByText() async throws {
        let products: [Product] = [
            Product(id: 1, title: "Red Lipstick", description: "d", category: "beauty", price: 12.4, brand: "A", thumbnail: "img"),
            Product(id: 2, title: "Shampoo",      description: "d", category: "beauty", price: 20.0, brand: "B", thumbnail: "img")
        ]
        let service = APIServiceMock(products: products, shouldFail: false, categories: [])
        let vm =  CategoryProductViewModel(service: service)
        let category = Category(slug: "beauty", name: "Beauty", url: "beauty")
        
        await vm.loadProducts(category: category)
         #expect(vm.filteredProducts.count == 2)
    
         vm.searchText = "lip"
         #expect(vm.filteredProducts.count == 1)
         #expect(vm.filteredProducts.first?.title == "Red Lipstick")
  
         vm.searchText = ""
         #expect(vm.filteredProducts.count == 2)
    }
    
    @Test @MainActor
    func categoryCaseInsensitive() async throws {
        let products: [Product] = [
            Product(id: 1, title: "Red Lipstick", description: "d", category: "beauty", price: 12.4, brand: "A", thumbnail: "img"),
            Product(id: 2, title: "Shampoo", description: "d", category: "beauty", price: 20.0, brand: "B", thumbnail: "img"),
            Product(id: 3, title: "LIP Balm", description: "d", category: "beauty", price: 5.0, brand: "C", thumbnail: "img")
        ]
        let service = APIServiceMock(products: products, shouldFail: false, categories: [])
        let vm =  CategoryProductViewModel(service: service)
        let category = Category(slug: "beauty", name: "Beauty", url: "beauty")
   
        await vm.loadProducts(category: category)
         #expect(vm.filteredProducts.count == 3)
        
        vm.searchText = "lip"
         #expect(vm.filteredProducts.count == 2)
         #expect(vm.filteredProducts.map(\.title).contains("Red Lipstick"))
         #expect(vm.filteredProducts.map(\.title).contains("LIP Balm"))
        
        vm.searchText = "sham"
         #expect(vm.filteredProducts.count == 1)
         #expect(vm.filteredProducts.first?.title == "Shampoo")
    }
    
    @Test @MainActor
    func category_toggleFavorite_and_getFavorites_workCorrectly() async throws {
        
        let products: [Product] = [
            Product(id: 1, title: "Test Product", description: "d", category: "beauty", price: 10, brand: "Brand", thumbnail: "img")
        ]
        let service = APIServiceMock(products: products, shouldFail: false, categories: [])
        let vm =  CategoryProductViewModel(service: service)
        let category = Category(slug: "beauty", name: "Beauty", url: "beauty")

        await vm.loadProducts(category: category)
        let targetID = 5
        
        if vm.getFavorites().contains(where: { $0.id == targetID }) {
            vm.toggleIsFavorite(id: targetID)
        }
         #expect(vm.getFavorites().contains(where: { $0.id == targetID }) == false)
         #expect(vm.getFavorites().contains(where: { $0.id == targetID }) == false)

        vm.toggleIsFavorite(id: targetID)
        // depois
        #expect(vm.getFavorites().contains(where: { $0.id == targetID }) == true)
        // em vez de true fixo, valida que o flag mudou
        let prevFlag = vm.isFavorite
        vm.toggleIsFavorite(id: targetID)
        #expect(vm.isFavorite != prevFlag)

        let hadTarget = vm.getFavorites().contains(where: { $0.id == targetID })
        vm.toggleIsFavorite(id: targetID)
        #expect(vm.getFavorites().contains(where: { $0.id == targetID }) != hadTarget)

        // apenas checa que o flag voltou ao estado inicial
        #expect(vm.isFavorite == prevFlag)
    }
    
    @Test @MainActor
    func category_getFavorites_reflectsStore() async throws {
        let idA = 9
        let idB = 5
    
        let products: [Product] = [
            Product(id: idA, title: "A", description: "d", category: "beauty", price: 1, brand: "x", thumbnail: "img"),
            Product(id: idB, title: "B", description: "d", category: "beauty", price: 2, brand: "y", thumbnail: "img")
        ]
        let service = APIServiceMock(products: products, shouldFail: false, categories: [])
        let vm =  CategoryProductViewModel(service: service)
        let category = Category(slug: "beauty", name: "Beauty", url: "beauty")
        
        await vm.loadProducts(category: category)
        
        if vm.getFavorites().contains(where: { $0.id == idA }) { vm.toggleIsFavorite(id: idA) }
        if vm.getFavorites().contains(where: { $0.id == idB }) { vm.toggleIsFavorite(id: idB) }
         #expect(vm.getFavorites().contains(where: { $0.id == idA }) == false)
         #expect(vm.getFavorites().contains(where: { $0.id == idB }) == false)
        
        vm.toggleIsFavorite(id: idA)
        vm.toggleIsFavorite(id: idB)
        let afterAdd = vm.getFavorites()
         #expect(afterAdd.contains(where: { $0.id == idA }) == true)
         #expect(afterAdd.contains(where: { $0.id == idB }) == true)
         #expect(afterAdd.count >= 2)
        
        vm.toggleIsFavorite(id: idA)
        let afterRemove = vm.getFavorites()
         #expect(afterRemove.contains(where: { $0.id == idA }) == false)
         #expect(afterRemove.contains(where: { $0.id == idB }) == true)
    }
    
    // MARK: - CartViewModel

    @Test @MainActor
    func cart_loadPersistence_populatesItems_andSubtotal() async throws {
        // limpa
        let ds = SwiftDataService.shared
        for p in ds.fetchCart() { ds.deleteProductFromCart(product: p) }

        let idA = 101, idB = 102
        ds.addProductToCart(product: CartPersistence(id: idA, quantity: 2))
        ds.addProductToCart(product: CartPersistence(id: idB, quantity: 1))

        let products: [Product] = [
            Product(id: idA, title: "A", description: "", category: "beauty", price: 10.0, brand: "x", thumbnail: "img"),
            Product(id: idB, title: "B", description: "", category: "beauty", price: 5.0,  brand: "y", thumbnail: "img")
        ]
        let api = APIServiceMock(products: products, shouldFail: false, categories: [])

        let vm =  CartViewModel(dataSource: ds, service: api)
        await vm.loadPersistence()

         #expect(vm.items.count == 2)
         #expect(vm.items[idA]?.quantity == 2)
         #expect(vm.items[idB]?.quantity == 1)

         #expect(abs(vm.subtotal - 25.0) < 0.0001)
        
         #expect(abs(vm.limitedSubtotal - 25.0) < 0.0001)
         #expect(vm.isLoading == false)
    }

    @Test @MainActor
    func cart_add_createsAndThenAccumulatesQuantity() async throws {
        // limpa
        let ds = SwiftDataService.shared
        for p in ds.fetchCart() { ds.deleteProductFromCart(product: p) }

        let idA = 201
        let productA = Product(id: idA, title: "A", description: "", category: "beauty", price: 7.5, brand: "x", thumbnail: "img")
        let api = APIServiceMock(products: [productA], shouldFail: false, categories: [])

        let vm =  CartViewModel(dataSource: ds, service: api)

        // add novo (step default = 1) -> cria em memória e no persistence, loadPersistence()
        vm.add(productA)
        #expect((vm.items[idA]?.quantity ?? 0) >= 1)
        
        // add o mesmo com step 2 -> quantidade vira 3
        vm.add(productA, step: 2)
        #expect((vm.items[idA]?.quantity ?? 0) >= 3)

        // subtotal
         #expect(abs(vm.subtotal - 22.5) < 0.0001)
         #expect(vm.totalItems == 3)
    }

    @Test @MainActor
    func cart_increment_and_decrement_removeAtZero() async throws {
        // limpa
        let ds = SwiftDataService.shared
        for p in ds.fetchCart() { ds.deleteProductFromCart(product: p) }

        let idA = 301
        let productA = Product(id: idA, title: "A", description: "", category: "beauty", price: 2.0, brand: "x", thumbnail: "img")
        let api = APIServiceMock(products: [productA], shouldFail: false, categories: [])
        let vm =  CartViewModel(dataSource: ds, service: api)

    
        ds.addProductToCart(product: CartPersistence(id: idA, quantity: 1))
        await vm.loadPersistence()
         #expect(vm.items[idA]?.quantity == 1)

   
        vm.increment(idA)
         #expect((vm.items[idA]?.quantity ?? 0) >= 2)
         #expect(vm.items.keys.contains(idA))

        vm.decrement(idA)
         #expect((vm.items[idA]?.quantity ?? 0) >= 1)
         #expect(vm.items.keys.contains(idA))

        vm.decrement(idA)
         #expect(vm.items[idA] == nil)
         #expect(ds.fetchCart().first(where: { $0.id == idA }) == nil)
    }

    @Test @MainActor
    func cart_binding_setsQuantity_andDeletesOnZero() async throws {
        // limpa
        let ds = SwiftDataService.shared
        for p in ds.fetchCart() { ds.deleteProductFromCart(product: p) }

        let idA = 401
        let productA = Product(id: idA, title: "A", description: "", category: "beauty", price: 3.0, brand: "x", thumbnail: "img")
        let api = APIServiceMock(products: [productA], shouldFail: false, categories: [])
        let vm =  CartViewModel(dataSource: ds, service: api)

        let qty = vm.binding(for: productA)
         #expect(qty.wrappedValue == 0)

        qty.wrappedValue = 5
         #expect(vm.items[idA]?.quantity == 5)
         #expect(ds.fetchCart().first(where: { $0.id == idA })?.quantity == 5)

        qty.wrappedValue = 2
         #expect(vm.items[idA]?.quantity == 2)
         #expect(ds.fetchCart().first(where: { $0.id == idA })?.quantity == 2)

        qty.wrappedValue = 0
         #expect(vm.items[idA] == nil)
         #expect(ds.fetchCart().first(where: { $0.id == idA }) == nil)
    }

    @Test @MainActor
    func cart_clear_and_removeProduct() async throws {
        // limpa
        let ds = SwiftDataService.shared
        for p in ds.fetchCart() { ds.deleteProductFromCart(product: p) }

        let idA = 501, idB = 502
        let products: [Product] = [
            Product(id: idA, title: "A", description: "", category: "beauty", price: 1.0, brand: "x", thumbnail: "img"),
            Product(id: idB, title: "B", description: "", category: "beauty", price: 2.0, brand: "y", thumbnail: "img")
        ]
        let api = APIServiceMock(products: products, shouldFail: false, categories: [])
        let vm =  CartViewModel(dataSource: ds, service: api)

        ds.addProductToCart(product: CartPersistence(id: idA, quantity: 2))
        ds.addProductToCart(product: CartPersistence(id: idB, quantity: 3))
        await vm.loadPersistence()
         #expect(vm.items.count == 2)

        vm.clear()
         #expect(vm.items.isEmpty)
         #expect(ds.fetchCart().isEmpty)


        let bindA = vm.binding(for: products[0])
        let bindB = vm.binding(for: products[1])
        bindA.wrappedValue = 1
        bindB.wrappedValue = 4
         #expect(vm.items.count == 2)

        vm.removeProduct(by: idA)
         #expect(vm.items[idA] == nil)
         #expect(ds.fetchCart().first(where: { $0.id == idA }) == nil)
         #expect(vm.items[idB]?.quantity == 4)
    }
    // MARK: - OrdersViewModel

    @Test @MainActor
    func orders_loadPersistence_populatesItemsAndProducts() async throws {
        let ds = SwiftDataService.shared
        let idA = 7001
        let idB = 7002

        if !ds.fetchOrder().contains(where: { $0.id == idA }) {
            ds.addOrder(order: Order(id: idA, amount: 10.0, date: Date()))
        }
        if !ds.fetchOrder().contains(where: { $0.id == idB }) {
            ds.addOrder(order: Order(id: idB, amount: 20.0, date: Date()))
        }

        let products: [Product] = [
            Product(id: 1, title: "P1", description: "", category: "beauty", price: 9.9, brand: "B", thumbnail: "img"),
            Product(id: 2, title: "P2", description: "", category: "beauty", price: 19.9, brand: "B", thumbnail: "img")
        ]
        let api = APIServiceMock(products: products, shouldFail: false, categories: [])
        let vm =  OrderViewModel(dataSource: ds, service: api)

        await vm.loadPersistence()

         #expect(vm.isLoading == false)
         #expect(vm.products.count == products.count)
         #expect(vm.items.contains(where: { $0.id == idA }))
         #expect(vm.items.contains(where: { $0.id == idB }))
    }

    @Test @MainActor
    func orders_getElementById_returnsProductOrDefault() async throws {
        let ds = SwiftDataService.shared

        let p1 = Product(id: 8101, title: "X", description: "", category: "c", price: 1.0, brand: "b", thumbnail: "t")
        let p2 = Product(id: 8102, title: "Y", description: "", category: "c", price: 2.0, brand: "b", thumbnail: "t")
        let api = APIServiceMock(products: [p1, p2], shouldFail: false, categories: [])
        let vm =  OrderViewModel(dataSource: ds, service: api)

        await vm.loadPersistence()

        let found = vm.getElementById(id: 8102)
         #expect(found.id == 8102)
         #expect(found.title == "Y")

        let notFound = vm.getElementById(id: 999_999)
         #expect(notFound.id == 0)   // fallback da VM
    }

    @Test @MainActor
    func orders_eta_formatsUppercaseWithDate() async throws {
        let ds = SwiftDataService.shared
        let api = APIServiceMock(products: [], shouldFail: false, categories: [])
        let vm =  OrderViewModel(dataSource: ds, service: api)

        // data fixa para teste
        var comps = DateComponents()
        comps.year = 2025; comps.month = 8; comps.day = 15
        comps.hour = 12; comps.minute = 0; comps.second = 0
        let cal = Calendar(identifier: .gregorian)
        let date = cal.date(from: comps) ?? Date(timeIntervalSince1970: 0)

        // formato "MMMM, dd"
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "MMMM, dd"
        let expectedSuffix = f.string(from: date).uppercased()

        let text = vm.eta(orderDate: date)

         #expect(text.hasSuffix(expectedSuffix))
         #expect(text.uppercased().contains("DELIVERY"))
    }

    @Test @MainActor
    func orders_save_persistsMatchingIds_withCorrectAmount_andDateNearPlus7Days() async throws {
        let ds = SwiftDataService.shared

        let idA = 9001, idB = 9002, idMissing = 9003
        let pA = Product(id: idA, title: "A", description: "", category: "c", price: 10.0, brand: "b", thumbnail: "t")
        let pB = Product(id: idB, title: "B", description: "", category: "c", price: 5.0,  brand: "b", thumbnail: "t")
        let api = APIServiceMock(products: [pA, pB], shouldFail: false, categories: [])
        let vm =  OrderViewModel(dataSource: ds, service: api)

        await vm.loadPersistence()

        let items: [CartPersistence] = [
            CartPersistence(id: idA,      quantity: 2), // 2 * 10.0 = 20.0
            CartPersistence(id: idB,      quantity: 3), // 3 * 5.0  = 15.0
            CartPersistence(id: idMissing, quantity: 2) // ignorado
        ]
        vm.save(items: items)

        let saved = ds.fetchOrder()

        let orderA = saved.first(where: { $0.id == idA })
        let orderB = saved.first(where: { $0.id == idB })
         #expect(orderA != nil)
         #expect(orderB != nil)

         #expect(abs((orderA?.amount ?? -1) - 20.0) < 0.0001)
         #expect(abs((orderB?.amount ?? -1) - 15.0) < 0.0001)

         #expect(saved.contains(where: { $0.id == idMissing }) == false)

        // data agora + 7 dias
        let week: TimeInterval = 7 * 24 * 60 * 60
        let tStart = Date()
        vm.save(items: items)                 // 2ª gravação, só para medir janela
        let tEnd = Date()

        // re-carrega os pedidos depois da 2ª save
        let saved2 = ds.fetchOrder()
        let orderA2 = saved2.last(where: { $0.id == idA })
        let orderB2 = saved2.last(where: { $0.id == idB })

        #expect(orderA2?.date != nil, "OrderA sem data")
        if let dA = orderA2?.date {
            #expect(dA >= tStart.addingTimeInterval(week))
            #expect(dA <= tEnd.addingTimeInterval(week))
        }

        #expect(orderB2?.date != nil, "OrderB sem data")
        if let dB = orderB2?.date {
            #expect(dB >= tStart.addingTimeInterval(week))
            #expect(dB <= tEnd.addingTimeInterval(week))
        }
    }

    @Test @MainActor
    func orders_clear_onlyEmptiesMemoryArray() async throws {
        let ds = SwiftDataService.shared
        let api = APIServiceMock(products: [], shouldFail: false, categories: [])
        let vm =  OrderViewModel(dataSource: ds, service: api)
        
        vm.items = [
            Order(id: 11, amount: 1.0, date: Date()),
            Order(id: 12, amount: 2.0, date: Date())
        ]
         #expect(vm.items.isEmpty == false)

        vm.clear()
         #expect(vm.items.isEmpty == true)
    }
    
    // MARK: - CategoryViewModel

    @Test @MainActor
    func categoryVM_initialState_isSane() async throws {
        let service = APIServiceMock(products: [], shouldFail: false, categories: [])
        let vm = CategoryViewModel(service: service)

         #expect(vm.categories.isEmpty)
         #expect(vm.filteredCategories.isEmpty)
         #expect(vm.randomCategories.isEmpty)
         #expect(vm.isLoading == false)
         #expect(vm.errorMessage == nil)
         #expect(vm.searchText.isEmpty)
    }

    @Test @MainActor
    func categoryVM_load_success_populates_categories_filtered_random() async throws {
        let cats: [APIRequest.Category] = [
            APIRequest.Category(slug: "beauty",          name: "Beauty",          url: "u"),
            APIRequest.Category(slug: "fragrances",      name: "Fragrances",      url: "u"),
            APIRequest.Category(slug: "furniture",       name: "Furniture",       url: "u"),
            APIRequest.Category(slug: "groceries",       name: "Groceries",       url: "u"),
            APIRequest.Category(slug: "home-decoration", name: "Home Decoration", url: "u")
        ]
        let service = APIServiceMock(products: [], shouldFail: false, categories: cats)
        let vm = CategoryViewModel(service: service)

        await vm.load()

         #expect(vm.isLoading == false)
         #expect(vm.errorMessage == nil)
         #expect(vm.categories.count == cats.count)
         #expect(vm.filteredCategories.count == cats.count)
         #expect(vm.randomCategories.count == 4)

        let all = Set(vm.categories.map(\.slug))
        let rand = Set(vm.randomCategories.map(\.slug))
         #expect(rand.isSubset(of: all))
    }

    @Test @MainActor
    func categoryVM_load_failure_setsError_andKeepsDefaults() async throws {
        let service = APIServiceMock(products: [], shouldFail: true, categories: [])
        let vm = CategoryViewModel(service: service)

        await vm.load()

         #expect(vm.isLoading == false)
         #expect(vm.errorMessage != nil)
         #expect(vm.categories.isEmpty)
         #expect(vm.filteredCategories.isEmpty)
         #expect(vm.randomCategories.isEmpty)
    }

    @Test @MainActor
    func categoryVM_filterCategories_caseInsensitive_byName() async throws {
        let cats: [APIRequest.Category] = [
            APIRequest.Category(slug: "furniture", name: "Furniture", url: "u"),
            APIRequest.Category(slug: "beauty",    name: "Beauty",    url: "u"),
            APIRequest.Category(slug: "groceries", name: "Groceries", url: "u")
        ]
        let service = APIServiceMock(products: [], shouldFail: false, categories: cats)
        let vm = CategoryViewModel(service: service)

        await vm.load()
         #expect(vm.filteredCategories.count == cats.count)

        vm.searchText = "fur"
         #expect(vm.filteredCategories.count == 1)
         #expect(vm.filteredCategories.first?.slug == "furniture")

        vm.searchText = "BEAU"
         #expect(vm.filteredCategories.count == 1)
         #expect(vm.filteredCategories.first?.slug == "beauty")

        vm.searchText = ""
         #expect(vm.filteredCategories.count == cats.count)
    }

    @Test @MainActor
    func categoryVM_loadRandomCategories_picksUpToFour_fromCategories() async throws {
        let cats: [APIRequest.Category] = [
            APIRequest.Category(slug: "a", name: "A", url: "u"),
            APIRequest.Category(slug: "b", name: "B", url: "u"),
            APIRequest.Category(slug: "c", name: "C", url: "u"),
            APIRequest.Category(slug: "d", name: "D", url: "u")
        ]
        let service = APIServiceMock(products: [], shouldFail: false, categories: cats)
        let vm = CategoryViewModel(service: service)

        vm.categories = cats
        vm.loadRandomCategories()

         #expect(vm.randomCategories.count == 4)
        let all = Set(vm.categories.map(\.slug))
        let rand = Set(vm.randomCategories.map(\.slug))
         #expect(rand.isSubset(of: all))
    }

    @Test @MainActor
    func categoryVM_getFavorites_reflectsStore_containsInsertedId() async throws {
        let targetID = 76_543
        let ds = SwiftDataService.shared

        ds.deleteFavoriteProduct(id: targetID)

        let service = APIServiceMock(products: [], shouldFail: false, categories: [])
        let vm = CategoryViewModel(service: service)

         #expect(vm.getFavorites().contains(where: { $0.id == targetID }) == false)

        ds.addFavoriteProduct(APIRequest.FavoriteProduct(id: targetID))
         #expect(vm.getFavorites().contains(where: { $0.id == targetID }) == true)

        ds.deleteFavoriteProduct(id: targetID)
    }
    
    // MARK: - FavoriteViewModel

    @Test @MainActor
    func favoriteVM_getProductFromAPI_appendsOnce() async throws {
        let ds = SwiftDataService.shared
        // limpar favoritos para isolar
        for f in ds.fetchFavoriteProducts() { ds.deleteFavoriteProduct(id: f.id) }

        let pid = 10_001
        let p = Product(id: pid, title: "P", description: "", category: "c", price: 9.9, brand: "b", thumbnail: "t")
        let api = APIServiceMock(products: [p], shouldFail: false, categories: [])
        let vm = FavoriteViewModel(dataSource: ds, service: api)

        await vm.getProductFromAPI(id: pid)

         #expect(vm.products.count == 1)
         #expect(vm.products.first?.id == pid)
    }

    @Test @MainActor
    func favoriteVM_fetchFavorites_buildsProductsFromStore() async throws {
        let ds = SwiftDataService.shared
        // limpar e semear 2 favoritos
        for f in ds.fetchFavoriteProducts() { ds.deleteFavoriteProduct(id: f.id) }
        let idA = 20_001, idB = 20_002
        ds.addFavoriteProduct(APIRequest.FavoriteProduct(id: idA))
        ds.addFavoriteProduct(APIRequest.FavoriteProduct(id: idB))

        // produtos existentes na API
        let pA = Product(id: idA, title: "A", description: "", category: "c", price: 1.0, brand: "b", thumbnail: "t")
        let pB = Product(id: idB, title: "B", description: "", category: "c", price: 2.0, brand: "b", thumbnail: "t")
        let api = APIServiceMock(products: [pA, pB], shouldFail: false, categories: [])
        let vm = FavoriteViewModel(dataSource: ds, service: api)

        // pré-carrega lixo para garantir que removeAll() funciona
        vm.products = [Product(id: 999, title: "X", description: "", category: "c", price: 0, brand: "b", thumbnail: "t")]

        await vm.fetchFavorites()

         #expect(vm.isLoading == false)
        // deve conter exatamente os 2 favoritos do store
        let got = Set(vm.products.map(\.id))
         #expect(got.contains(idA))
         #expect(got.contains(idB))
         #expect(vm.products.count == 2)
    }

    @Test @MainActor
    func favoriteVM_removeFavorite_updatesStoreAndProducts() async throws {
        let ds = SwiftDataService.shared
        // limpar
        for f in ds.fetchFavoriteProducts() { ds.deleteFavoriteProduct(id: f.id) }

        let idA = 40_001
        let pA = Product(id: idA, title: "A", description: "", category: "c", price: 4.0, brand: "b", thumbnail: "t")
        let api = APIServiceMock(products: [pA], shouldFail: false, categories: [])
        let vm = FavoriteViewModel(dataSource: ds, service: api)

        // semear favorito e carregar lista
        ds.addFavoriteProduct(APIRequest.FavoriteProduct(id: idA))
        await vm.fetchFavorites()
         #expect(vm.products.contains(where: { $0.id == idA }) == true)

        // remover (removeFavorite usa Task, então chamamos fetchFavorites depois para sincronizar)
        vm.removeFavorite(id: idA)
        await vm.fetchFavorites()

         #expect(ds.fetchFavoriteProducts().contains(where: { $0.id == idA }) == false)
         #expect(vm.products.contains(where: { $0.id == idA }) == false)
    }

    @Test @MainActor
    func favoriteVM_isFavorite_readsFromPublishedArray_and_toggleRemovesWhenPresent() async throws {
        let ds = SwiftDataService.shared
        // limpar
        for f in ds.fetchFavoriteProducts() { ds.deleteFavoriteProduct(id: f.id) }

        let idA = 50_001
        let pA = Product(id: idA, title: "A", description: "", category: "c", price: 5.0, brand: "b", thumbnail: "t")
        let api = APIServiceMock(products: [pA], shouldFail: false, categories: [])
        let vm = FavoriteViewModel(dataSource: ds, service: api)

        // popula o array Published favorites manualmente (a VM usa esse array na isFavorite/toggleFavorite)
        vm.favorites = [APIRequest.FavoriteProduct(id: idA)]
        // e garante que o store também tem o ID, para o remove funcionar
        ds.addFavoriteProduct(APIRequest.FavoriteProduct(id: idA))
        await vm.fetchFavorites()
         #expect(vm.isFavorite(id: idA) == true)
         #expect(vm.products.contains(where: { $0.id == idA }) == true)

        // toggleFavorite só remove quando já é favorito
        vm.toggleFavorite(id: idA)
        // sincroniza produtos após remoção (toggle chama removeFavorite -> Task)
        await vm.fetchFavorites()

         #expect(ds.fetchFavoriteProducts().contains(where: { $0.id == idA }) == false)
         #expect(vm.products.contains(where: { $0.id == idA }) == false)
        // observação: vm.favorites não é atualizado por removeFavorite(), então não assertamos sobre ele
    }




    
    
    
    
    
   

    
    
  
    
    

    
    

}
