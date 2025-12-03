import 'dart:math';
import 'dart:isolate';

Future<void> task(int id) async {
  int delay = Random().nextInt(15) + 1;

  print('task $id va travailler $delay secondes');

  await Future.delayed(Duration(seconds: delay));

  print('task $id COMPLETED');
}

void taskIsolateEntryPoint(List<dynamic> args) {
  final int id = args[0] as int;
  final SendPort sendPort = args[1] as SendPort;

  task(id).then((_) {
    sendPort.send(id);
  });
}

Future<void> main() async {
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
