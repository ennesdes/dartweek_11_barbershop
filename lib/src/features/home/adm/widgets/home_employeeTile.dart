// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:project_barbershop_dartweek/src/core/ui/barbershop_icon.dart';
import 'package:project_barbershop_dartweek/src/core/ui/constants.dart';
import 'package:project_barbershop_dartweek/src/models/user_model.dart';

class HomeEmployeeTile extends StatelessWidget {
  final UserModel employee;

  const HomeEmployeeTile({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorsConstants.grey,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: switch (employee.avatar) {
                  final avatar? => NetworkImage(avatar),
                  _ => const AssetImage(ImageConstants.avatar),
                } as ImageProvider,
                // precisa do ImageProvider pq um dos retornos é diferente, ai deixa todos iguais
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  employee.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/schedule',
                          arguments: employee,
                        );
                      },
                      child: const Text('AGENDAR'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/employee/schedule',
                          arguments: employee,
                        );
                      },
                      child: const Text('VER AGENDA'),
                    ),
                    const Icon(
                      BarbershopIcons.penEdit,
                      size: 16,
                      color: ColorsConstants.brow,
                    ),
                    const Icon(
                      BarbershopIcons.trash,
                      size: 16,
                      color: ColorsConstants.red,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}