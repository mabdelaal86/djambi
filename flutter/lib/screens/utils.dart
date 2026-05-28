import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openUrl(String url) {
  final uri = Uri.parse(url);
  return launchUrl(uri);
}

Future<bool?> confirm(BuildContext context, String title, String message, {bool barrierDismissible = true}) =>
    showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
          TextButton(
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
        ],
      ),
    );

Future<void> alert(BuildContext context, String title, String message, {bool barrierDismissible = true}) =>
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
