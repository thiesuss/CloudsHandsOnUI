import 'package:logger/logger.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/models/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repo<T> implements StatefullObj {
  Map<String, CachedObj<T>> _items = {}; //ID -> Item

  Repo(this._fromJson, this._toJson);

  Future<void> init() async {}
  Future<void> dispose() async {
    await clean();
  }

  Future<CachedObj<T>> get(String id) async {
    return _items[id]!;
  }

  List<CachedObj<T>> getAll() {
    return _items.values.toList();
  }

  void add(CachedObj<T> item) {
    // TODO: do not use dynamic
    String id = item.getId();
    bool exists = _items.containsKey(id);
    if (exists) {
      _items[id]!.setObj(item.getObj(), clean: item.isClean());
    } else {
      _items[id] = item;
    }
  }

  Future<void> delete(String id) async {
    bool exists = _items.containsKey(id);
    if (exists) {
      final cachedObj = _items[id]!;
      await cachedObj.dispose();
      _items.remove(id);
    }
  }

  Future<void> clean() async {
    await Future.wait(_items.values.map((e) => e.dispose()).toList());
    _items.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // O(n), kann man optimieren
    await Future.wait(prefs
        .getKeys()
        .where((k) => k.startsWith("${T.runtimeType}."))
        .map((k) => prefs.remove(k))
        .toList());
  }

  Future<void> persist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final objs = getAll();
    await Future.wait(objs.map((e) async {
      final id = e.getId();
      await prefs.setString("${T.runtimeType}.$id", _toJson(e));
    }));
  }

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final loadedItems = prefs
        .getKeys()
        .where((k) => k.startsWith("${T.runtimeType}."))
        .map((key) {
          final json = prefs.getString(key);
          if (json == null) {
            Logger().e("Could not load $key from SharedPreferences");
            return null;
          }
          final obj =
              _fromJson(json); // Use the factory function to deserialize
          final id = key.substring("${T.runtimeType}.".length);
          return CachedObj<T>(id, obj, clean: false);
        })
        .where((element) => element != null)
        .toList() as List<CachedObj<T>>;

    await Future.wait(loadedItems.map((e) => e.init()));

    loadedItems.forEach((element) {
      add(element);
    });
  }

  final T Function(String) _fromJson;
  final String Function(CachedObj<T>) _toJson;
}
