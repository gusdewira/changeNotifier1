class TodoModel {
  int? id, harga,stok;
  String? namaProduk,gambar;

  TodoModel({this.id, this.namaProduk, this.gambar, this.harga, this.stok});

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaProduk = json['nama_produk'];
    harga = json['harga'];
    stok = json['stok'];
    gambar = json['gambar'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama_produk': namaProduk,
        'harga' : harga,
        'stok': stok,
        'gambar': gambar
      };
}