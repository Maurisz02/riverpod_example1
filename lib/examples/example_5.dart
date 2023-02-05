import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart'; //to create unique user id for this example

//this is example 5
//with a plus button you can create a person with name and age and display on the screen
//you can update that displayed person's data
//everything stored in the memory in this example

//a simple person class with some data
// can call the setter method like get or something in a simple person
@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person(
      {required this.name,
      required this.age,
      String? uuid //this is optional because w generate this
      })
      : uuid = uuid ??
            const Uuid()
                .v4(); //if no uuid passed then generate a random this is the deault value

//this gets called when we update an exsit Person class element
  Person updated([String? name, int? age]) => Person(
        name: name ?? this.name,
        age: age ?? this.age,
        uuid: uuid,
      );

//this is the display form
  String get displayName => '$name ($age years old)';

//we will place in a list and we need to know which person is which
//we chechk if this is the same person
  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

//write he result to the console to see if everything is correct
  @override
  String toString() => 'Person(name: $name, age: $age, uuid: $uuid)';
}

//this class is where all the changes happen and it contains all the pre defined persons in a list
//this is a data model class from the Person class
class DataModel extends ChangeNotifier {
//a list of People class
  final List<Person> _people = [];

//get the length of the list
  int get count => _people.length;

//this is where yu can get the list of the people the window to the app and this class to get _people list
  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

//function to add new person
  void addPeople(Person person) {
    _people.add(person);

//need to tell the code that something has been changed
    notifyListeners();
  }

  void removePersone(Person person) {
    _people.remove(person);

//need to tell the code that something has been changed
    notifyListeners();
  }

  void updatePerson(Person updatedPerson) {
    //search the updatedPerson's index
    //its know where the new is because it has a nique uuid
    final index = _people.indexOf(updatedPerson);

//we store that person
    final oldPerson = _people[index];

    if (oldPerson.name != updatedPerson.name ||
        oldPerson.age != updatedPerson.age) {
      _people[index] = oldPerson.updated(updatedPerson.name, updatedPerson.age);
      notifyListeners();
    }
  }
}

//ChangeNotifier - ChangeNotifierProvider which is provide the changeNotifier value
final peopleProvider = ChangeNotifierProvider((_) => DataModel());

class MyHomePage5 extends ConsumerWidget {
  const MyHomePage5({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();

//return a new person model, an updated person model or nothing
    Future<Person?> createOrUpdatePersonDialog(
      BuildContext context,
      //lehet null amikor ujat akarunk létre hozni de akkor le kell kezelnunk
      [
      Person? existingPerson,
    ]) {
      String? name = existingPerson?.name;
      int? age = existingPerson?.age;

      nameController.text = name ?? '';
      ageController.text = age.toString();

      return showDialog<Person?>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Create a person',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Enter name here...'),
                    onChanged: (value) => name = value,
                  ),
                  TextField(
                    controller: ageController,
                    decoration:
                        const InputDecoration(labelText: 'Enter age here...'),
                    onChanged: (value) => age = int.tryParse(value),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    //if we write sometingto name and age field
                    if (name != null && age != null) {
                      //update an existing person
                      if (existingPerson != null) {
                        final newPerson = existingPerson.updated(name, age);
                        Navigator.of(context).pop(newPerson);
                        //create a new person
                      } else {
                        Navigator.of(context).pop(
                          //! means its sure that it has value
                          //? means its value can be null
                          //here the name and age value cant be null because we handle it carefully
                          Person(name: name!, age: age!),
                        );
                      }
                      //if the values are null
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Riverpod Person Creator ChangeNotifier - ChangeNotifierProvider'),
      ),
      body: Consumer(builder: (ctx, ref, ch) {
        final dataModel = ref.watch(peopleProvider);

        return ListView.builder(
            itemCount: dataModel.count,
            itemBuilder: (ctx, i) {
              final person = dataModel.people[i];
              return ListTile(
                title: GestureDetector(
                  onTap: () async {
                    final updatedPerson =
                        await createOrUpdatePersonDialog(ctx, person);
                    if (updatedPerson != null) {
                      dataModel.updatePerson(updatedPerson);
                    }
                  },
                  child: Text(person.displayName),
                ),
              );
            });
      }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            //because we set the pop value to the person class
            final person = await createOrUpdatePersonDialog(context);
            //not null means if in the alertdialog we fill the gaps or we dont press the cancel button
            if (person != null) {
              //we just read because we just need a snapshot
              final dataModel = ref.read(peopleProvider);
              dataModel.addPeople(person);
            }
          }),
    );
  }
}
