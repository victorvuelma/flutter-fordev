import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';

import '../../factories.dart';

Widget makeLoginPage() {
  final LoginPresenter presenter =
      Get.put<LoginPresenter>(makeGetxLoginPresenter());

  return LoginPage(presenter);
}
