import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_barbershop_dartweek/src/core/providers/application_providers.dart';
import 'package:project_barbershop_dartweek/src/core/ui/helpers/messages.dart';
import 'package:project_barbershop_dartweek/src/core/ui/widgets/avatar_widget.dart';
import 'package:project_barbershop_dartweek/src/core/ui/widgets/barbershop_loader.dart';
import 'package:project_barbershop_dartweek/src/core/ui/widgets/hours_panel.dart';
import 'package:project_barbershop_dartweek/src/core/ui/widgets/weekdays_panel.dart';
import 'package:project_barbershop_dartweek/src/features/employee/register/employee_register_state.dart';
import 'package:project_barbershop_dartweek/src/features/employee/register/employee_register_vm.dart';
import 'package:project_barbershop_dartweek/src/models/barbershop_model.dart';
import 'package:validatorless/validatorless.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  var registerADM = false;
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
    final employeeRegisterVM = ref.watch(employeeRegisterVmProvider.notifier);
    final barbershopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(employeeRegisterVmProvider.select((state) => state.status),
        (_, status) {
      switch (status) {
        case EmployeeRegisterStateStatus.initial:
          break;
        case EmployeeRegisterStateStatus.success:
          Messages.showSuccess('Colaborador cadastrado com sucesso', context);
          Navigator.of(context).pop();
        case EmployeeRegisterStateStatus.error:
          Messages.showError('Erro ao registrar colaborador', context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar colaborador'),
      ),
      body: barbershopAsyncValue.when(
        error: (error, stackTrace) {
          log(
            'Erro ao carregar a página',
            error: error,
            stackTrace: stackTrace,
          );
          return const Center(
            child: Text('Erro ao carregar a página'),
          );
        },
        loading: () => const BarbershopLoader(),
        data: (barbershopModel) {
          final BarbershopModel(:openingDays, :openingHours) = barbershopModel;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    children: [
                      const AvatarWidget(),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: registerADM,
                            onChanged: (value) {
                              setState(() {
                                registerADM = !registerADM;
                                employeeRegisterVM.setRegisterADM(registerADM);
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Sou administrador e quero me cadastrar como colaborador',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: registerADM,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: nameEC,
                              validator: registerADM
                                  ? null
                                  : Validatorless.required('Nome obrigatório'),
                              decoration:
                                  const InputDecoration(label: Text('Nome')),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: emailEC,
                              validator: registerADM
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                          'E-mail obrigatório'),
                                      Validatorless.email('E-mail inválido')
                                    ]),
                              decoration:
                                  const InputDecoration(label: Text('E-mail')),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: passwordEC,
                              obscureText: true,
                              validator: registerADM
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                          'Senha obrigatória'),
                                      Validatorless.min(6,
                                          'Senha deve ter no mínimo 6 caracteres'),
                                    ]),
                              decoration:
                                  const InputDecoration(label: Text('Senha')),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      WeekdaysPanel(
                        enabledDays: openingDays,
                        onDayPressed: employeeRegisterVM.addOrRemoveWorkDays,
                      ),
                      const SizedBox(height: 24),
                      HoursPanel(
                        enabledTimes: openingHours,
                        startTime: 6,
                        endTime: 23,
                        onHourPressed: employeeRegisterVM.addOrRemoveWorkHours,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          switch (formKey.currentState?.validate()) {
                            case false || null:
                              Messages.showError(
                                'Existem campos inválidos',
                                context,
                              );
                            case true:
                              final EmployeeRegisterState(
                                workDays: List(isNotEmpty: hasWorkDays),
                                workHours: List(isNotEmpty: hasWorkHours)
                              ) = ref.watch(
                                employeeRegisterVmProvider,
                              );

                              if (!hasWorkDays || !hasWorkHours) {
                                Messages.showError(
                                  'Por favor selecione os dias da semana e horário de atendimento',
                                  context,
                                );
                              }

                              final name = nameEC.text;
                              final email = emailEC.text;
                              final password = passwordEC.text;

                              employeeRegisterVM.register(
                                name: name,
                                email: email,
                                password: password,
                              );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        child: const Text('CADASTRAR COLABORADOR'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}