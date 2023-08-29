import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';
import '../data/todo_model.dart';

List<Map<String, dynamic>> dataFromServer = [
  {'id': 1, 'nama_produk': 'Mangga', 'harga': 15000, 'stok': 20, 'gambar': 'https://example.com/Grape.jpg'},
  {'id': 2, 'nama_produk': 'Jeruk', 'harga': 10000, 'stok': 50, 'gambar': 'https://example.com/Grape.jpg'},
  {'id': 3, 'nama_produk': 'Anggur', 'harga': 12000, 'stok': 30, 'gambar': 'https://example.com/Grape.jpg'}
];

class TodoNotifider extends ChangeNotifier {
  List<TodoModel> todos = [];
  bool isLoading = false;

  Future getTodos() async {
    try {
      isLoading = true;
      await Future.delayed(1.s);

      todos = dataFromServer.map((e) => TodoModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      isLoading = false;
    }
  }
    
  void add(TodoModel data) {
    try {
      todos.add(data);
      notifyListeners();
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  void update(int id, TodoModel data) {
    try {
      final index = todos.indexWhere((e) => e.id == id);
      if (index > -1) {
        todos[index] = data;
        notifyListeners();
      }
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  void delete(int id) {
    try {
      todos.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  TodoNotifider(){
    getTodos();
  }
}