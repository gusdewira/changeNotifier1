import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';
import '../data/todo_model.dart';
import '../notifiers/todo_notofier.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = TodoNotifider();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          const Icon(Ti.plus).onPressed(() {
            context.push(FormTodo(notifier: notifier));
          })
        ],
      ),
      body: notifier.watch((state) {
        if (state.isLoading) {
          return LzLoader.bar(message: 'Loading...');
        }

        return
            Refreshtor(
              onRefresh: () => state.getTodos(),
              child: LzListView(
                children: state.todos.generate((item, i) {
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
                                  onConfirm: () => state.delete(item.id!))
                              .show(context);
                        }
                      });
                    },
                    padding: Ei.sym(v: 20),
                    border: Br.only(['t'], except: i == 0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage('https://e0.pxfuel.com/wallpapers/688/852/desktop-wallpaper-pin-oleh-aury-otaku-di-doraemon-dengan-gambar-doraemon-kartun-yellow-doraemon.jpg'),
                          radius: 50,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item.namaProduk}',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                            Text('Harga: ${item.harga}'),
                            Text('Stok: ${item.stok}')
                          ],
                        ),
                      ],
                    ),
                    
                  );
                }),
              ),
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
          title: const Text('Form Edit Produk'),
        ),
        body: LzFormList(
          children: [
            LzForm.input(
                label: 'Nama Produk',
                hint: 'Masukan Nama Produk',
                model: forms['nama_produk'],
                autofocus: true
                ),
                LzForm.input(
                  label: 'Harga Produk',
                  hint: 'Masukan Harga Produk',
                  model: forms['harga'],
                  autofocus: true
                ),
                LzForm.input(
                  label: 'Stok Produk',
                  hint: 'Masukan Stok Produk',
                  model: forms['stok'],
                  autofocus: true
                ),
                LzForm.input(
                  label: 'gambar Produk',
                  hint: 'Masukan URL Gambar Produk',
                  model: forms['gambar'],
                  autofocus: true
                ),
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
                    messages:
                        FormMessages(required: {'nama_produk': 'Title harus diisi'}));
        
                if (form.ok) {
                  // jika data tidak null, maka update
                  if (data != null) {
                    notifier.update(data!.id!,
                        TodoModel.fromJson({'id': data?.id, ...form.value}));
                    context.pop();
                    return;
                  }
        
                  int id = DateTime.now().millisecondsSinceEpoch;
                  final payload = {
                    'id': id,
                    ...form.value
                  };
                  notifier.add(TodoModel.fromJson(payload));
                  context.pop();
                }
              }).theme1(),
        ),
      ),
    );
  }
}