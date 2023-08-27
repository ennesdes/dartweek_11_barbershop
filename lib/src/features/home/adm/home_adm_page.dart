import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_barbershop_dartweek/src/core/providers/application_providers.dart';
import 'package:project_barbershop_dartweek/src/core/ui/barbershop_icon.dart';
import 'package:project_barbershop_dartweek/src/core/ui/constants.dart';
import 'package:project_barbershop_dartweek/src/core/ui/widgets/barbershop_loader.dart';
import 'package:project_barbershop_dartweek/src/features/home/adm/home_adm_state.dart';
import 'package:project_barbershop_dartweek/src/features/home/adm/home_adm_vm.dart';
import 'package:project_barbershop_dartweek/src/features/home/adm/widgets/home_employeeTile.dart';
import 'package:project_barbershop_dartweek/src/features/home/widgets/home_header.dart';

class HomeAdmPage extends ConsumerWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeAdmVmProvider);

    return Scaffold(
      body: homeState.when(
        data: (HomeAdmState data) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: data.employees.length,
                  (context, index) => HomeEmployeeTile(
                    employee: data.employees[index],
                  ),
                ),
              ),
            ],
          );
        },
        error: ((error, stackTrace) {
          log(
            'Erro ao buscar colaboradores',
            error: error,
            stackTrace: stackTrace,
          );
          return const Center(
            child: Text('Erro ao carregar página'),
          );
        }),
        loading: () {
          return const BarbershopLoader();
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ColorsConstants.brow,
        onPressed: () async {
          await Navigator.of(context).pushNamed('/employee/register');
          ref.invalidate(getMeProvider);
          ref.invalidate(homeAdmVmProvider);
        },
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(
            BarbershopIcons.addEmployee,
            color: ColorsConstants.brow,
          ),
        ),
      ),
    );
  }
}
