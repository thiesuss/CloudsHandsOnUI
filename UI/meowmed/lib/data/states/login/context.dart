import 'package:meowmed/data/states/login/initial.dart';
import 'package:meowmed/data/states/login/state.dart';
import 'package:rxdart/rxdart.dart';

class LoginStateContext {
  BehaviorSubject<LoginState?> _state = BehaviorSubject.seeded(null);

  BehaviorSubject<LoginState?> get state => _state;

  LoginStateContext() {
    _state.listen((value) {
      print("State changed to $value");
    });
    final newState = LoginStateInitial(this);
    _state.add(newState);
    newState.init();
  }
}
