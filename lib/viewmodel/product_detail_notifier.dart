import 'package:fashn_app/model/product_model.dart';
import 'package:fashn_app/services/api_services.dart';
import 'package:riverpod/riverpod.dart';

class ProductDetailNotifier extends StateNotifier<AsyncValue<Product?>> {
  final ApiService _apiService = ApiService();

  ProductDetailNotifier(int productId) : super(const AsyncValue.loading()) {
    _fetchProductDetail(productId);
  }

  Future<void> _fetchProductDetail(int productId) async {
    try {
      final product = await _apiService.fetchProductDetail(productId);
      state = AsyncValue.data(product);
    } catch (e, stack) {
      // Capture and include the stack trace
      state = AsyncValue.error(e, stack);
    }
  }
}

final productDetailProvider = StateNotifierProvider.family<
    ProductDetailNotifier, AsyncValue<Product?>, int>((ref, productId) {
  return ProductDetailNotifier(productId);
});
