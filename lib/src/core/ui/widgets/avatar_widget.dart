import 'package:flutter/material.dart';
import 'package:project_barbershop_dartweek/src/core/ui/barbershop_icon.dart';
import 'package:project_barbershop_dartweek/src/core/ui/constants.dart';

class AvatarWidget extends StatelessWidget {
  final hideUploadButton;

  const AvatarWidget({
    super.key,
    this.hideUploadButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 105,
      height: 105,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstants.avatar),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Offstage(
              offstage: hideUploadButton,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorsConstants.brow, width: 4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  BarbershopIcons.addEmployee,
                  color: ColorsConstants.brow,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
