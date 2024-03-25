import 'package:meowmed/data/states/login/initial.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:rxdart/rxdart.dart';

class LoginStateContext {
  // TODO: auf injectable umstellen
  static LoginStateContext getInstance() {
    if (_instance == null) {
      _instance = LoginStateContext._internal();
    }
    return _instance!;
  }

  static LoginStateContext? _instance;

  LoginStateContext._internal() {
    print("LoginStateContext created");
    state.listen((value) {
      print("State changed to $value");
    });
    final newState = LoginStateInitial();
    notifyOfStateChange(newState);
  }

  BehaviorSubject<LoginState?> _state = BehaviorSubject.seeded(null);
  Stream<LoginState?> get state => _state.stream;

  void notifyOfStateChange(LoginState state) {
    _state.add(state);
    state.init();
  }
}
