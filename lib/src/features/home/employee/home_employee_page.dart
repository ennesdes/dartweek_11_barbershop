import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_barbershop_dartweek/src/core/providers/application_providers.dart';
import 'package:project_barbershop_dartweek/src/core/ui/constants.dart';
import 'package:project_barbershop_dartweek/src/core/ui/widgets/avatar_widget.dart';
import 'package:project_barbershop_dartweek/src/core/ui/widgets/barbershop_loader.dart';
import 'package:project_barbershop_dartweek/src/features/home/employee/home_employee_provider.dart';
import 'package:project_barbershop_dartweek/src/features/home/widgets/home_header.dart';
import 'package:project_barbershop_dartweek/src/models/user_model.dart';

class HomeEmployeePage extends ConsumerWidget {
  const HomeEmployeePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);

    return Scaffold(
      body: userModelAsync.when(
        error: (error, stackTrace) {
          return const Center(
            child: Text('Erro ao carregar página'),
          );
        },
        loading: () => const BarbershopLoader(),
        data: (userModel) {
          final UserModel(:name, :id) = userModel;

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader(
                  hideFilter: true,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const AvatarWidget(
                        hideUploadButton: true,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .7,
                        height: 108,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorsConstants.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final totalAsync = ref.watch(
                                  getTotalSchedulesTodayProvider(id),
                                );

                                return totalAsync.when(
                                  loading: () => const BarbershopLoader(),
                                  skipLoadingOnRefresh: false,
                                  error: (error, stackTrace) {
                                    return const Center(
                                      child: Text(
                                        'Erro ao carregar total de agendamento',
                                      ),
                                    );
                                  },
                                  data: (data) {
                                    return Text(
                                      data.toString(),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: ColorsConstants.brow,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const Text(
                              'Hoje',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                            '/schedule',
                            arguments: userModel,
                          );
                          ref.invalidate(getTotalSchedulesTodayProvider);
                        },
                        child: const Text('AGENDAR CLIENTE'),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/employee/schedule',
                            arguments: userModel,
                          );
                        },
                        child: const Text('VER AGENDA'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
