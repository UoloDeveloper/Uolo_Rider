import 'package:flutter/material.dart';

// class BottomNavItemWidget extends StatelessWidget {
//   final IconData iconData;
//   final Function? onTap;
//   final bool isSelected;
//   const BottomNavItemWidget({super.key, required this.iconData, this.onTap, this.isSelected = false});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: IconButton(
//         icon: Icon(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.grey, size: 25),
//         onPressed: onTap as void Function()?,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class BottomNavItemWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Function? onTap;
  final bool isSelected;

  const BottomNavItemWidget({
    super.key,
    required this.iconData,
    required this.label,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                size: 25,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
