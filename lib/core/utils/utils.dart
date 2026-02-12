import 'dart:io';

class Utils {
  static String? get getHomePath {
    return Platform.environment['HOME'];
  }

  static String getProjectRootPath() {
    return getHomePath!.joinPath('projects');
  }
}

extension StringExt on String {
  String joinPath(String name) {
    return '$this${Platform.pathSeparator}$name';
  }
}
