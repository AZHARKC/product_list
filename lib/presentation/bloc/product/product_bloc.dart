import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  int _skip = 0;
  final int _limit = 10;
  bool _isLoading = false;

  ProductBloc(this.repository) : super(const ProductState.initial()) {
    on<ProductEvent>(_onEvent);
  }

  Future<void> _onEvent(ProductEvent event, Emitter<ProductState> emit) async {
    switch (event) {
      case Started():
        emit(const ProductState.loading());

        try {

          final localProducts = await repository.getCachedProducts();
          if (localProducts.isNotEmpty) {
            emit(ProductState.loaded(localProducts));
          }


          _skip = 0;
          await repository.fetchAndCacheProducts(skip: _skip, limit: _limit);
          final updatedProducts = await repository.getCachedProducts();

          emit(ProductState.loaded(updatedProducts));
        } catch (e) {

          final fallback = await repository.getCachedProducts();
          if (fallback.isNotEmpty) {
            emit(ProductState.loaded(fallback));
          } else {
            emit(ProductState.error('No internet and no local data.'));
          }
        }
        break;


      case LoadMore():
        if (_isLoading) return;
        _isLoading = true;
        _skip += _limit;

        try {

          final newProducts = await repository.fetchProductsOnly(skip: _skip, limit: _limit);

          if (newProducts.isEmpty) {

            final all = await repository.getCachedProducts();
            emit(ProductState.noMoreData(all));
          } else {

            await repository.cacheProducts(newProducts);


            final updated = await repository.getCachedProducts();
            emit(ProductState.loaded(updated));
          }
        } catch (e) {
          final cached = await repository.getCachedProducts();
          if (cached.isNotEmpty) {
            emit(ProductState.loaded(cached));
          } else {
            emit(ProductState.error(e.toString()));
          }
        } finally {
          _isLoading = false;
        }
        break;

    }
  }
}
