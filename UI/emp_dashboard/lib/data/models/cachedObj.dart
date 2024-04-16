import 'package:meowmed/data/models/service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachedObj<T> implements StatefullObj {
  CachedObj(String id, T obj, {bool clean = true}) {
    _id = id;
    _obj = obj;
    _clean = clean;
    _isDeleted = false;
  }

  late String _id;
  late bool _clean;
  late T _obj;
  late bool _isDeleted;

  bool isDeleted() => _isDeleted;

  void setDeleted() {
    _isDeleted = true;
  }

  void setClean() {
    _clean = true;
  }

  void setDirty() {
    _clean = false;
  }

  bool isClean() => _clean;
  bool isDirty() => !_clean;

  T getObj() {
    return _obj;
  }

  void setObj(T obj, {bool clean = true}) {
    _onUpdate.add(null);
    this._obj = obj;
  }

  String getId() {
    return _id;
  }

  // TODO: dont use BehaviorSubject
  final Subject<void> _onUpdate = BehaviorSubject<void>();
  Stream<void> get stream => _onUpdate.stream;

  @override
  Future<void> dispose() async {
    await _onUpdate.close();
  }

  @override
  Future<void> init() {
    return Future.value();
  }
}
