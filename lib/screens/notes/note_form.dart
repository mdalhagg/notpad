import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_pad/models/category.dart';
import 'package:note_pad/models/note.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;
  final int? index;

  const NoteFormScreen({super.key, this.note, this.index});

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note?.title ?? '';
      _contentController.text = widget.note?.content ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Category>? categoryBox = Hive.box('note_categories')
            .get('note_categories')
            ?.map((e) => Category.fromJson(e))
            .toList()
            ?.cast<Category>() ??
        [];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Update Note'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
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
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: '1',
                  items: List.generate(
                    categoryBox?.length ?? 0,
                    (index) => DropdownMenuItem(
                      value: categoryBox?[index].id.toString(),
                      child: Text(categoryBox?[index].name.toString() ?? ''),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final title = _titleController.text;
            final content = _contentController.text;
            final note = Note(title: title, content: content);
            if (widget.note == null) {
              await NotesService().addNote(note);
            } else {
              await NotesService().updateNote(widget.index!, note);
            }
            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class NotesService {
  addNote(Note note) async {
    await Hive.openBox('notes');
    var box = await Hive.box('notes').get('notes');
    if (box == null) {
      box = [];
    } else {
      box = box.toList();
    }
    if (box.where((element) => element['title'] == note.title).isNotEmpty) {
      return;
    } else {
      box.add({
        'title': note.title,
        'content': note.content,
        // 'category': note.categoryId,
        'isPinned': note.isPinned ?? false,
        'isArchived': note.isArchived ?? false,
        'createdAt': DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
      });
    }
    await Hive.box('notes').put('notes', box);
    print('box');
  }

  updateNote(int index, Note note) {
    var box = Hive.box('notes').get('notes');
    box[index] = {
      'title': note.title,
      'content': note.content,
      // 'category': note.categoryId,
      'isPinned': note.isPinned ?? false,
      'isArchived': note.isArchived ?? false,
      'createdAt': DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
    };
    Hive.box('notes').put('notes', box);
  }
}
