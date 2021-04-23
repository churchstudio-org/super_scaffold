import 'dart:async';

import 'package:flutter/widgets.dart';

class SuperScaffoldController {
  String? confirmationMessage;
  
  ValueNotifier<bool> waitingConfirmation = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Completer<bool>? confirmationCompleter;

  Future<bool> waitConfirmation(String message) async {
    confirmationCompleter = Completer();
    confirmationMessage = message;
    waitingConfirmation.value = true;

    return confirmationCompleter!.future;
  }

  void acceptConfirmation() async {
    waitingConfirmation.value = false;
    confirmationCompleter!.complete(true);
  }

  void cancelConfirmation() {
    waitingConfirmation.value = false;
    confirmationCompleter!.complete(false);
  }

  void showLoading() => isLoading.value = true;
  void hideLoading() => isLoading.value = false;
}