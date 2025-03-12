import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinDialog extends StatefulWidget {
  final Function(String) onSubmit;
  final VoidCallback? onForgotPin;
  final bool isSettingPin;
  final String buttonText;

  PinDialog({
    required this.onSubmit,
    this.onForgotPin,
    this.isSettingPin = false,
    this.buttonText = '',
  });

  @override
  _PinDialogState createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isSettingPin
                  ? AppLocalizations.of(context)!.setPinTitle
                  : AppLocalizations.of(context)!.loginTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.pinHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            if (!widget.isSettingPin && widget.onForgotPin != null)
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.forgotPinTitle),
                      content: Text(AppLocalizations.of(context)!.forgotPinMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onForgotPin!();
                            Navigator.pop(context); // Close confirmation
                            Navigator.pop(context); // Close PinDialog
                          },
                          child: Text('Delete'), // Could localize this too, but kept simple
                        ),
                      ],
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.forgotPin),
              ),
            ElevatedButton(
              onPressed: () => widget.onSubmit(_pinController.text),
              child: Text(
                widget.buttonText.isNotEmpty
                    ? widget.buttonText
                    : (widget.isSettingPin
                    ? AppLocalizations.of(context)!.save
                    : AppLocalizations.of(context)!.unlock),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}