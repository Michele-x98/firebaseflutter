import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future? errorSnackbar(String message) => Get.showSnackbar(
      GetBar(
        title: 'Error',
        message: message,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.info_outline_rounded),
        shouldIconPulse: true,
      ),
    );

Future? completeSnackbar(String message) => Get.showSnackbar(
      GetBar(
        title: 'Done',
        message: message,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        shouldIconPulse: true,
        icon: Icon(Icons.done_rounded),
      ),
    );
