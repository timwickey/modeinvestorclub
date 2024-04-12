import 'package:flutter/widgets.dart';

/// A mock authentication service
class ModeAuth extends ChangeNotifier {
  bool _signedIn = false;

  bool get signedIn => _signedIn;

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Sign in. Allow any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
  }

  @override
  bool operator ==(Object other) =>
      other is ModeAuth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;

  static ModeAuth of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ModeAuthScope>()!.notifier!;
}

class ModeAuthScope extends InheritedNotifier<ModeAuth> {
  const ModeAuthScope({
    required super.notifier,
    required super.child,
    super.key,
  });
}
