import 'package:flutter/widgets.dart';
import 'package:modeinvestorclub/src/backend.dart';

/// A mock authentication service
class ModeAuth extends ChangeNotifier {
  bool _signedIn = false;

  bool get signedIn => _signedIn;
  ApiResponse? _user; // Remove 'late'

  ApiResponse? get user => _user;

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign out.
    _signedIn = false;
    _user = null;
    notifyListeners();
  }

  Future<bool> signIn(ApiResponse user) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Sign in. Allow any password.
    _signedIn = true;
    _user = user;
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
