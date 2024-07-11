import 'package:flutter/material.dart';

class ItemTypeWidget extends StatelessWidget {
  Map<String, dynamic> data;
  bool isSelected;
  VoidCallback tap;

  ItemTypeWidget({
    required this.data,
    required this.isSelected,
    required this.tap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.cyan.withOpacity(0.3)
              : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              data["image"],
              height: 40,
              width: 40,
            ),
            SizedBox(width: 8),
            Text(data["name"]),
          ],
        ),
      ),
    );
  }
}
