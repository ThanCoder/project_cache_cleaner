//dart compile exe bin/my_cli_app.dart -o myapp
import 'package:interact/interact.dart';
import 'package:project_cleaner/flutter_project_cleaner.dart';

void main() async {
  final languages = ['Flutter', 'Nodejs'];
  final selection = Select(
    prompt: 'Project Cleaner',
    options: languages,
  ).interact();

  if (selection == 0) {
    FlutterProjectCleaner();
    return;
  }
  print('Not Supported!');
}
