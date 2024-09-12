import 'package:fashn_app/model/product_model.dart';
import 'package:fashn_app/services/api_services.dart';
import 'package:riverpod/riverpod.dart';

class ProductListNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ApiService _apiService = ApiService();

  ProductListNotifier() : super(const AsyncValue.loading()) {
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await _apiService.fetchProducts();
      state = AsyncValue.data(products);
    } catch (e, stack) {
      // Here, we capture the error and stack trace
      state = AsyncValue.error(e, stack);
    }
  }
}

final productListProvider =
    StateNotifierProvider<ProductListNotifier, AsyncValue<List<Product>>>(
        (ref) {
  return ProductListNotifier();
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');
