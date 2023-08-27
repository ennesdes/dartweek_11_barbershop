import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_barbershop_dartweek/src/core/ui/helpers/form_helper.dart';
import 'package:project_barbershop_dartweek/src/core/ui/helpers/messages.dart';
import 'package:project_barbershop_dartweek/src/features/auth/register/user/user_register_vm.dart';
import 'package:validatorless/validatorless.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRegisterVM = ref.watch(userRegisterVmProvider.notifier);

    ref.listen(userRegisterVmProvider, (_, state) {
      switch (state) {
        case UserRegisterStateStatus.initial:
          break;
        case UserRegisterStateStatus.success:
          Navigator.of(context).pushNamed('/auth/register/barbershop');
        case UserRegisterStateStatus.error:
          Messages.showError(
            'Erro ao registrar usuário administrador',
            context,
          );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cirar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Nome'),
                  ),
                  controller: nameEC,
                  validator: Validatorless.required('Nome obrigatório'),
                  onTapOutside: (_) => context.unfocus(),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                  controller: emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido'),
                  ]),
                  onTapOutside: (_) => context.unfocus(),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Senha'),
                  ),
                  controller: passwordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatória'),
                    Validatorless.min(
                        6, 'Senha deve ter no mínimo 6 caracteres'),
                  ]),
                  obscureText: true,
                  onTapOutside: (_) => context.unfocus(),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Confirmar Senha'),
                  ),
                  validator: Validatorless.multiple([
                    Validatorless.required('Confirmar Senha obrigatória'),
                    Validatorless.compare(
                      passwordEC,
                      'Senha diferente de Confirmar Senha',
                    )
                  ]),
                  obscureText: true,
                  onTapOutside: (_) => context.unfocus(),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () {
                    switch (formKey.currentState?.validate()) {
                      case null || false:
                        Messages.showError('Formulário inválido', context);
                      case true:
                        userRegisterVM.register(
                          name: nameEC.text,
                          email: emailEC.text,
                          password: passwordEC.text,
                        );
                    }
                  },
                  child: const Text('CRIAR CONTA'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
