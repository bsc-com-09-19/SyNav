import 'package:get_storage/get_storage.dart';

class KLocalStorage {
  static final KLocalStorage _instance = KLocalStorage._internal();

  factory KLocalStorage() {
    return _instance;
  }

  KLocalStorage._internal();

  final _storage = GetStorage();

  //Generic method to save data
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // Generc method to read data
  T? readData<T>(String key) {
    return _storage.read(key);
  }

  // Generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data in storage 
  Future<void> clearAll() async {
    _storage.erase();
  }
}
