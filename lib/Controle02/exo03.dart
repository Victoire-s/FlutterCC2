import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PersonnesModel(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: PersonneUIWidget(),
          ),
        ),
      ),
    );
  }
}


class Personne {
  String nom;
  String prenom;
  int age;

  Personne(this.nom, this.prenom, this.age);

  String getNomComplet() => '$prenom $nom';
}

class PersonnesModel extends ChangeNotifier {
  final List<Personne> personnes = [
    Personne('Smith', 'Arthur', 3),
    Personne('Doe', 'Jane', 25),
    Personne('Dupont', 'Jean', 40),
  ];

  int selectedIndex = 0;

  Personne get selectedPersonne => personnes[selectedIndex];

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void anniversaire() {
    personnes[selectedIndex].age++;
    notifyListeners();
  }
}


class PersonneUIWidget extends StatelessWidget {
  const PersonneUIWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PersonnesModel>();

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: const PersonneList(),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PersonneForm(),
              const SizedBox(height: 8),
              const PersonneCat(),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => model.anniversaire(),
                child: const Text('Anniversaire'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PersonneList extends StatelessWidget {
  const PersonneList({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PersonnesModel>();

    return ListView.builder(
      itemCount: model.personnes.length,
      itemBuilder: (context, index) {
        final p = model.personnes[index];
        final selected = index == model.selectedIndex;

        return ListTile(
          selected: selected,
          title: Text(p.getNomComplet()),
          subtitle: Text('Age : ${p.age}'),
          onTap: () => context.read<PersonnesModel>().setIndex(index),
        );
      },
    );
  }
}

class PersonneForm extends StatelessWidget {
  const PersonneForm({super.key});

  @override
  Widget build(BuildContext context) {
    final personne = context.watch<PersonnesModel>().selectedPersonne;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nom : ${personne.nom}'),
        Text('Prénom : ${personne.prenom}'),
        Text('Âge : ${personne.age}'),
      ],
    );
  }
}

class PersonneCat extends StatelessWidget {
  const PersonneCat({super.key});

  @override
  Widget build(BuildContext context) {
    final age = context.watch<PersonnesModel>().selectedPersonne.age;

    switch (age) {
      case < 10:
        return const Text('Enfant');
      case < 18:
        return const Text('Adolescent');
      case < 65:
        return const Text('Adulte');
      default:
        return const Text('Senior');
    }
  }
}
