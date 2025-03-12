import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/pin_dialog.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  Future<void> _checkPin() async {
    if (!await _authService.hasPin()) {
      _showSetPinDialog();
    } else {
      _showLoginDialog();
    }
  }

  void _showSetPinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PinDialog(
        isSettingPin: true,
        onSubmit: (pin) async {
          if (pin.length == 4) {
            await _authService.setPin(pin);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
          }
        },
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PinDialog(
        onSubmit: (pin) async {
          if (await _authService.verifyPin(pin)) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid PIN')));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}