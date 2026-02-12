import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:interact/interact.dart';
import 'package:project_cleaner/core/utils/utils.dart';

class FlutterProjectCleaner {
  String? path;
  int cleanedCount = 0;

  FlutterProjectCleaner() {
    final select = Select(
      prompt: 'Your Root Path: `$path`',
      options: ['Set Root Path'],
    ).interact();

    if (select == 0) {
      final rootPath = Input(
        prompt: 'Clean Project Root Path',
        defaultValue: Utils.getProjectRootPath(),
        initialText: path ?? Utils.getProjectRootPath(),
      ).interact();
      path = rootPath;
      _cleanProjects();
    }
  }

  void _cleanProjects() async {
    final rootDir = Directory(path!);

    if (!await rootDir.exists()) {
      print('Error: လမ်းကြောင်း မှားယွင်းနေပါသည်။');
      return;
    }
    print('\nScanning for Flutter projects...\n');

    // ၂။ Directory တွေကို လိုက်ရှာမယ်
    cleanedCount = 0;

    await _dirScanner(rootDir);

    print('\n--- အားလုံးပြီးစီးပါပြီ ---');
    print('စုစုပေါင်း Project ($cleanedCount) ခုကို ရှင်းလင်းပြီးပါပြီ။');
  }

  Future<void> _dirScanner(Directory dir) async {
    for (var entry in dir.listSync(followLinks: false)) {
      // print('send entry: $entry');
      // file
      final pubspec = File('${entry.path}/pubspec.yaml');

      if (await pubspec.exists()) {
        final content = await pubspec.readAsString();
        if (content.contains('sdk: flutter') || content.contains('flutter:')) {
          await _cleanFlutterProject(entry.getDirectory);
        }
        continue;
      }
      if (entry.isDirectory) {
        await _dirScanner(entry.getDirectory);
      }
    }
  }

  Future<void> _cleanFlutterProject(Directory projectDir) async {
    // --- Flutter Project ဖြစ်ခဲ့လျှင် ---
    print('Cleaning Flutter project: ${projectDir.path}');
    await Process.run('flutter', ['clean'], workingDirectory: projectDir.path);
    cleanedCount++;
  }
}
