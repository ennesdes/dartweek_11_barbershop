import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_barbershop_dartweek/src/core/ui/constants.dart';
import 'package:project_barbershop_dartweek/src/core/ui/helpers/form_helper.dart';
import 'package:project_barbershop_dartweek/src/core/ui/helpers/messages.dart';
import 'package:project_barbershop_dartweek/src/features/auth/login/login_state.dart';
import 'package:project_barbershop_dartweek/src/features/auth/login/login_vm.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// a instancia e não o estado
    final LoginVm(:login) = ref.watch(loginVmProvider.notifier);

    ref.listen(loginVmProvider, (_, state) {
      switch (state) {
        case LoginState(status: LoginStateStatus.initial):
          break;
        case LoginState(status: LoginStateStatus.error, :final errorMessage?):
          Messages.showError(errorMessage, context);
        case LoginState(status: LoginStateStatus.error):
          Messages.showError('Erro ao realizar login', context);
        case LoginState(status: LoginStateStatus.admLogin):
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home/adm',
            (route) => false,
          );
          break;
        case LoginState(status: LoginStateStatus.employeeLogin):
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home/employee',
            (route) => false,
          );
          break;
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstants.backgroundChair,
              ),
              opacity: 0.2,
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageConstants.imageLogo),
                          const SizedBox(height: 24),
                          TextFormField(
                            onTapOutside: (_) => context.unfocus(),
                            validator: Validatorless.multiple([
                              Validatorless.required('E-mail obrigatório'),
                              Validatorless.email('E-mail inválido'),
                            ]),
                            controller: emailEC,
                            decoration: const InputDecoration(
                              label: Text('E-mail'),
                              hintText: 'E-mail',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            onTapOutside: (_) => context.unfocus(),
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha Obrigatória'),
                              Validatorless.min(
                                6,
                                'Senha deve conter pelo menos 6 caracteres',
                              ),
                            ]),
                            obscureText: true,
                            controller: passwordEC,
                            decoration: const InputDecoration(
                              label: Text('Senha'),
                              hintText: 'Senha',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              child: const Text(
                                'Esqueceu a senha?',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorsConstants.brow,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              switch (formKey.currentState?.validate()) {
                                case (false || null):
                                  Messages.showError(
                                    'Campos inválidos',
                                    context,
                                  );
                                  break;
                                case true:
                                  login(emailEC.text, passwordEC.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                            child: const Text('Acessar'),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/auth/register/user',
                            );
                          },
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
