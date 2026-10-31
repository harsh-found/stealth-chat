import 'dart:math';
import 'package:flutter/material.dart';

class ZeroFlickerKeyboardTray extends StatefulWidget {
  final Widget child;
  final bool isTrayOpen;
  final Widget? trayContent;
  final double defaultTrayHeight;

  const ZeroFlickerKeyboardTray({
    super.key,
    required this.child,
    required this.isTrayOpen,
    this.trayContent,
    this.defaultTrayHeight = 280.0,
  });

  @override
  State<ZeroFlickerKeyboardTray> createState() =>
      _ZeroFlickerKeyboardTrayState();
}

class _ZeroFlickerKeyboardTrayState extends State<ZeroFlickerKeyboardTray>
    with WidgetsBindingObserver {
  double _cachedKeyboardHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _cachedKeyboardHeight = widget.defaultTrayHeight;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Cache the keyboard height when it appears
    final bottomInset = WidgetsBinding
            .instance.platformDispatcher.views.first.viewInsets.bottom /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    if (bottomInset > 100.0) {
      setState(() {
        _cachedKeyboardHeight = bottomInset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (keyboardHeight > 100.0 && keyboardHeight != _cachedKeyboardHeight) {
      _cachedKeyboardHeight = keyboardHeight;
    }

    final effectiveTrayHeight =
        max(_cachedKeyboardHeight, widget.defaultTrayHeight);

    return Column(
      children: [
        Expanded(child: widget.child),
        // If tray is open and keyboard is down, hold the exact keyboard height
        if (widget.isTrayOpen && keyboardHeight == 0)
          SizedBox(
            height: effectiveTrayHeight,
            width: double.infinity,
            child: widget.trayContent,
          ),
      ],
    );
  }
}
