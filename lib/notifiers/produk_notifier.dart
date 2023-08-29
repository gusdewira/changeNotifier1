import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';
import '../data/produk_model.dart';

List<Map<String, dynamic>> dataProduk = [
  {'id': 1, 'nama_produk': 'Mangga', 'harga': 15000, 'stok': 20, 'gambar': 'https://example.jpg'},
  {'id': 2, 'nama_produk': 'Jeruk', 'harga': 10000, 'stok': 50, 'gambar': 'https://example.jpg'},
  {'id': 3, 'nama_produk': 'Anggur', 'harga': 12000, 'stok': 30, 'gambar': 'https://example.jpg'}
];

class TodoNotifider extends ChangeNotifier {
  List<TodoModel> produks = [];
  bool isLoading = false;

  Future getTodos() async {
    try {
      isLoading = true;
      await Future.delayed(1.s);

      produks = dataProduk.map((e) => TodoModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      isLoading = false;
    }
  }

void search(String query) {
  try {
    final searchProduks = dataProduk
        .where((produk) =>
            produk['nama_produk'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    produks = searchProduks.map((e) => TodoModel.fromJson(e)).toList();
    notifyListeners();
  } catch (e, s) {
    Errors.check(e, s);
  }
}

  void add(TodoModel data) {
    try {
      produks.add(data);
      notifyListeners();
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  void update(int id, TodoModel data) {
    try {
      final index = produks.indexWhere((e) => e.id == id);
      if (index > -1) {
        produks[index] = data;
        notifyListeners();
      }
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  void delete(int id) {
    try {
      produks.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e, s) {
      Errors.check(e, s);
    }
  }

  TodoNotifider(){
    getTodos();
  }
}