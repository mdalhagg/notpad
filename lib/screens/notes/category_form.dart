import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_pad/models/category.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? category;
  final int? index;
  const CategoryFormScreen({super.key, this.category, this.index});

  @override
  _CategoryFormScreenState createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category?.name ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.category == null ? 'Add Category' : 'Update Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final name = _nameController.text;
            final category = Category(name: name);
            if (widget.category != null) {
              await NotesService().updateCategory(widget.index!, category);
            } else {
              await NotesService().addCategory(category);
            }
            context.pop();
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class NotesService {
  addCategory(Category category) async {
    var box = await Hive.box('note_categories').get('note_categories');
    if (box == null) {
      box = [];
    } else {
      box = box.toList();
    }
    if (box.where((element) => element['name'] == category.name).isNotEmpty) {
      return;
    } else {
      box.add({
        'id': box.isNotEmpty ? (box.last['id'] ?? 0) + 1 : 1,
        'name': category.name,
      });
    }
    await Hive.box('note_categories').put('note_categories', box);
    print('box');
  }

  updateCategory(int index, Category category) {
    var box = Hive.box('note_categories').get('note_categories');
    if (box != null) {
      box = box.toList();
      box[index]['name'] = category.name;
      Hive.box('note_categories').put('note_categories', box);
    }
    print('box');
  }
}
