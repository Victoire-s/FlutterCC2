import 'dart:math';

Future<void> task(int id) async {
  int delay = Random().nextInt(15) + 1;

  print('task $id va travailler $delay secondes');

  await Future.delayed(Duration(seconds: delay));

  print('task $id COMPLETED');
}

Future<void> main() async {
  print('début du main');

  await task(89);

  print('fin du main');
}
