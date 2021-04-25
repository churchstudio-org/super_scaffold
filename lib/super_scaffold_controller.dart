import 'dart:async';

import 'package:flutter/widgets.dart';

class SuperScaffoldController {
  String? confirmationMessage;
  
  ValueNotifier<bool> waiting = ValueNotifier(false);

  Completer<bool>? confirmation;
  Completer? loading;

  bool get isConfirming => confirmation != null && !confirmation!.isCompleted;
  bool get isLoading => loading != null && !loading!.isCompleted;

  Future<bool> confirm(String message) async {
    confirmation = Completer();
    confirmationMessage = message;
    waiting.value = true;

    return confirmation!.future;
  }

  void acceptConfirmation() async {
    waiting.value = false;
    confirmation!.complete(true);
  }

  void cancelConfirmation() {
    if (!confirmation!.isCompleted) {
      waiting.value = false;
      confirmation!.complete(false);
    }
  }

  Completer wait() {
    loading = Completer();
    waiting.value = true;

    loading!.future.whenComplete(() {
      waiting.value = false;
    });

    return loading!;
  }
}