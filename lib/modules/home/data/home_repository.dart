// modules/home/data/home_repository.dart

import 'home_datasource.dart';
import '../models/item_model.dart';

class HomeRepository {
  final HomeDatasource datasource;

  HomeRepository(this.datasource);

  /// 🔥 MOCK
  Future<List<ItemModel>> getItems() => datasource.getItemsMock();

  Future<void> saveItem(ItemModel item) => datasource.saveItemMock(item);

  Future<void> deleteItem(int index) => datasource.deleteItemMock(index);

  Future<void> clearItems() => datasource.clearItemsMock();

  // ----------------------------------------------------------
  // 🚀 FUTURO (BACKEND REAL)
  // ----------------------------------------------------------

  /*
  Future<List<ItemModel>> getItems() => datasource.getItemsFromApi();
  Future<void> saveItem(ItemModel item) => datasource.saveItemOnline(item);
  Future<void> deleteItem(int id) => datasource.deleteItemOnline(id);
  Future<void> clearItems() => datasource.clearItemsOnline();
  */
}
