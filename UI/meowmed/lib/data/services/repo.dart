import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/models/service.dart';

class Repo<T> implements StatefullObj {
  Map<String, CachedObj<T>> _items = {}; //ID -> Item

  Future<void> init() async {}
  Future<void> dispose() async {
    await clean();
  }

  Future<CachedObj<T>> get(String id) async {
    return _items[id]!;
  }

  Future<List<CachedObj<T>>> getAll() async {
    return _items.values.toList();
  }

  void add(CachedObj<T> item) {
    // TODO: do not use dynamic
    String id = (item as dynamic).id;
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
  }
}
