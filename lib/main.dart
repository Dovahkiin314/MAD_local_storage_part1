import 'package:flutter/material.dart';
import 'services/database_helper.dart';

// Global database helper
final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQFlite Demo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _insert,
                child: const Text('Insert'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _query,
                child: const Text('Query All'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _update,
                child: const Text('Update'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _delete,
                child: const Text('Delete'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _queryById,
                child: const Text('Query by ID (1)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _deleteAll,
                child: const Text('Delete All'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Button logic

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    debugPrint('Inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('Query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('Updated $rowsAffected row(s)');
  }

  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('Deleted $rowsDeleted row(s): row $id');
  }

  // Query a specific record by ID
  void _queryById() async {
    const id = 1;
    final row = await dbHelper.queryRowById(id);
    if (row != null) {
      debugPrint('Found row with ID $id: $row');
    } else {
      debugPrint('No record found with ID $id');
    }
  }

  // Delete all records
  void _deleteAll() async {
    final rowsDeleted = await dbHelper.deleteAll();
    debugPrint('Deleted $rowsDeleted row(s) total.');
  }
}
