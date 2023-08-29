import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';
import '../data/produk_model.dart';

List<Map<String, dynamic>> dataProduk = [
  {'id': 1, 'nama_produk': 'Mangga', 'harga': 15000, 'stok': 20, 'gambar': 'https://e0.pxfuel.com/wallpapers/688/852/desktop-wallpaper-pin-oleh-aury-otaku-di-doraemon-dengan-gambar-doraemon-kartun-yellow-doraemon.jpg'},
  {'id': 2, 'nama_produk': 'Jeruk', 'harga': 10000, 'stok': 50, 'gambar': 'https://e0.pxfuel.com/wallpapers/688/852/desktop-wallpaper-pin-oleh-aury-otaku-di-doraemon-dengan-gambar-doraemon-kartun-yellow-doraemon.jpg'},
  {'id': 3, 'nama_produk': 'Anggur', 'harga': 12000, 'stok': 30, 'gambar': 'https://e0.pxfuel.com/wallpapers/688/852/desktop-wallpaper-pin-oleh-aury-otaku-di-doraemon-dengan-gambar-doraemon-kartun-yellow-doraemon.jpg'}
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
    if (query.isEmpty) {
      // Jika query kosong, tampilkan semua produk
      produks = List.from(produks);
    } else {
      // Jika query tidak kosong, filter produk berdasarkan query
      produks = produks.where((item) {
        final lowerCaseQuery = query.toLowerCase();
        final lowerCaseNamaProduk = item.namaProduk!.toLowerCase();
        return lowerCaseNamaProduk.contains(lowerCaseQuery);
      }).toList();
    }
    notifyListeners(); // Memberi tahu perubahan dalam hasil pencarian
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