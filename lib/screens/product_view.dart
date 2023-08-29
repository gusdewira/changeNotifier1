import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';
import '../data/produk_model.dart';
import '../notifiers/produk_notifier.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = TodoNotifider();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Tombol Pencarian
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              TextField(onChanged: (query) {
                notifier.search(query);
              });
            },
          ),
          const Icon(Ti.plus).onPressed(() {
            context.push(FormTodo(notifier: notifier));
          })
        ],
      ),
      body: notifier.watch((state) {
        if (state.isLoading) {
          return LzLoader.bar(message: 'Loading...');
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Refreshtor(
                onRefresh: () => state.getTodos(),
                child: LzListView(
                  children: state.produks.generate((item, i) {
                    final key = GlobalKey();

                    return InkTouch(
                      key: key,
                      onTap: () {
                        DropX.show(key,
                            options: ['Edit', 'Delete'].options(
                                icons: [Ti.pencil, Ti.trash],
                                dangers: [1]), onSelect: (value) {
                          if (value.option == 'Edit') {
                            context.push(FormTodo(
                              notifier: notifier,
                              data: item,
                            ));
                          } else {
                            LzConfirm(
                                title: 'Hapus',
                                type: LzConfirmType.bottomSheet,
                                message: 'Anda yakin ingin menghapus data ini?',
                                onConfirm: () =>
                                    state.delete(item.id!)).show(context);
                          }
                        });
                      },
                      padding: Ei.sym(v: 20),
                      border: Br.only(['t'], except: i == 0),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(
                                  '${item.gambar}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.namaProduk}',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Rp.${item.harga}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class FormTodo extends StatelessWidget {
  final TodoNotifider notifier;
  final TodoModel? data;
  const FormTodo({super.key, required this.notifier, this.data});

  @override
  Widget build(BuildContext context) {
    final forms = LzForm.make(['nama_produk']);

    if (data != null) {
      forms.fill(data!.toJson());
    }

    return Wrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form Produk'),
        ),
        body: LzFormList(
          children: [
            LzForm.input(
                label: 'Nama Produk',
                hint: 'Masukan Nama Produk',
                model: forms['nama_produk'],
                autofocus: true),
            LzForm.input(
                label: 'Harga Produk',
                hint: 'Masukan Harga Produk',
                model: forms['harga'],
                autofocus: true),
            LzForm.input(
                label: 'Stok Produk',
                hint: 'Masukan Stok Produk',
                model: forms['stok'],
                autofocus: true),
            LzForm.input(
                label: 'gambar Produk',
                hint: 'Masukan URL Gambar Produk',
                model: forms['gambar'],
                autofocus: true),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LzButton(
              text: 'Submit',
              onTap: (state) {
                // validasi form
                final form = LzForm.validate(forms,
                    required: ['*'],
                    messages: FormMessages(
                        required: {'nama_produk': 'Title harus diisi'}));

                if (form.ok) {
                  if (data != null) {
                    notifier.update(data!.id!,
                        TodoModel.fromJson({'id': data?.id, ...form.value}));
                    context.pop();
                    return;
                  }

                  int id = DateTime.now().millisecondsSinceEpoch;
                  final payload = {'id': id, ...form.value};
                  notifier.add(TodoModel.fromJson(payload));
                  context.pop();
                }
              }).theme1(),
        ),
      ),
    );
  }
}
