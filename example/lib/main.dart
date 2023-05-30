import 'package:flutter/material.dart';

import 'app.dart';
import 'json_demo_build_app.dart';

void main() {
  const isInternalJsonBuild = bool.fromEnvironment('IS_INTERNAL_JSON_BUILD');
  if (isInternalJsonBuild) {
    runApp(const JsonDemoBuildApp());
  } else {
    runApp(const App());
  }
}
