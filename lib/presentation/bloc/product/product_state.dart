import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/product_model.dart';

part 'product_state.freezed.dart';

@freezed
sealed class ProductState with _$ProductState {
  const factory ProductState.initial() = Initial;
  const factory ProductState.loading() = Loading;
  const factory ProductState.loaded(List<ProductModel> products) = Loaded;
  const factory ProductState.noMoreData(List<ProductModel> products) = NoMoreData;
  const factory ProductState.error(String message) = Error;
}
