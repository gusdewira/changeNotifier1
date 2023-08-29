import 'package:change_notifier/screens/product_view.dart';
import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = AuthNotifier();

    notifier.forms.fill({'email': 'admin@gmail.com', 'password': '12345'});

    return Wrapper(
      child: Scaffold(
        body: Center(
          child: LzListView(
            shrinkWrap: true,
            scrollLimit: const [30],
            padding: Ei.only(v: 35, h: 40),
            onScroll: (controller) {},
            children: [
              const Column(
                children: <Widget>[
                  Text(
                    'Selamat Datang Di Menu Login',
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ).margin(b: 25),
              LzFormGroup(
                bottomSpace: 10,
                children: [
                  LzForm.input(
                      label: 'Email',
                      keyboard: Tit.emailAddress,
                      model: notifier.forms['email']),
                  LzForm.input(
                      label: 'Password',
                      obsecureToggle: true,
                      model: notifier.forms['password']),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              LzButton(
                  text: 'Login',
                  color: Colors.blue,
                  onTap: (state) async {
                    state.submit();
                    await Future.delayed(1.s);

                    bool ok = await notifier.signin();
                    state.abort();

                    if (ok) {
                      if (context.mounted) {
                        context.pushAndRemoveUntil(const ProductView());
                      }
                    } else {
                      LzToast.show('Email atau password salah');
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class AuthNotifier extends ChangeNotifier {
  final forms = LzForm.make(['email', 'password']);

  Future<bool> signin() async {
    try {
      final form = LzForm.validate(forms,
          required: ['email', 'password'],
          messages: FormMessages(required: {
            'email': 'Alamat email tidak boleh kosong',
            'password': 'Password tidak boleh kosong'
          }));

      if (form.ok) {
        if (form.value['email'] == 'admin@gmail.com' &&
            form.value['password'] == '12345') {
          return true;
        }
      }
    } catch (e, s) {
      Errors.check(e, s);
    }

    return false;
  }
}
