import 'dart:math';
import 'dart:isolate';


Future<void> task(int id) async {
  int delay = Random().nextInt(15) + 1;

  print('task $id va travailler $delay secondes');

  await Future.delayed(Duration(seconds: delay));

  print('task $id COMPLETED');
}

Future<void> runEx1() async {
  print('=== Exercice 1 ===');
  print('début du main');

  await task(89);

  print('fin du main');
}

void taskIsolateEntryPoint(List<dynamic> args) {
  final int id = args[0] as int;
  final SendPort sendPort = args[1] as SendPort;

  task(id).then((_) {
    sendPort.send(id);
  });
}

Future<void> runEx2() async {
  print('=== Exercice 2 ===');
  print('début du main');

  final receivePort = ReceivePort();
  await Isolate.spawn(
    taskIsolateEntryPoint,
    [89, receivePort.sendPort],
  );

  print('main continue pendant que l’isolate travaille...');

  final completedId = await receivePort.first as int;
  print('Isolate terminé pour la task id: $completedId');

  receivePort.close();

  print('fin du main');
}

Future<void> runEx3() async {
  print('=== Exercice 3 ===');
  print('début du main');

  final receivePort = ReceivePort();
  final isolates = <Isolate>[];

  final ids = [1, 2, 3];

  for (final id in ids) {
    final isolate = await Isolate.spawn(
      taskIsolateEntryPoint,
      [id, receivePort.sendPort],
    );
    isolates.add(isolate);
  }

  print('3 tasks lancées dans 3 isolates, le main attend la première fin...');

  final firstCompletedId = await receivePort.first as int;
  print('Première task finie: id = $firstCompletedId');

  for (final isolate in isolates) {
    isolate.kill(priority: Isolate.immediate);
  }

  receivePort.close();

  print('fin du main');
}


Future<void> main() async {
  await runEx3();
}
