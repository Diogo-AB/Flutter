import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puc_minas/app/core/constants/app_assets.dart';
import 'package:puc_minas/app/core/constants/app_routes.dart';
import 'package:puc_minas/app/features/login/login_controler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final cpfEC = TextEditingController();
  final passwordEC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LOGIN'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(AppAssets.logo),
                  TextFormField(
                    controller: cpfEC,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.cpf('O CPF é inválido'),
                        Validatorless.required('O campo é brigatório'),
                      ],
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CpfInputFormatter()],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Insira seu CPF'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordEC,
                    validator: Validatorless.multiple([Validatorless.required('O campo é obrigatório'), Validatorless.min(6, 'Minímo 6 caracteres')]),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: 'Insira sua senha'),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      bool valid = formKey.currentState?.validate() ?? false;
                      if (valid) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.info(message: 'Carregando...'),
                        );
                        bool success = await LoginControler.login(cpf: cpfEC.text.replaceAll('.', '').replaceAll('-', ''), password: passwordEC.text);
                        if (success == true) {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.success(message: 'Concluido'),
                          );
                          Navigator.of(context).pushNamed(AppRoutes.home);
                        } else {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(message: 'Os dados informados não conferem'),
                          );
                        }
                      }
                    },
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Aceitar'),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.login),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
