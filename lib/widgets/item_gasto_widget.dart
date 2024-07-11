import 'package:flutter/material.dart';
import 'package:gastosappg8/models/gasto_model.dart';
import 'package:gastosappg8/utils/data_general.dart';

class ItemGastoWidget extends StatelessWidget {
  final GastoModel gasto;
  final VoidCallback onDelete;

  ItemGastoWidget({
    required this.gasto,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Image.asset(
          _getImagePath(gasto.type),
          height: 40,
          width: 40,
        ),
        title: Text(
          gasto.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          gasto.datetime,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "S/ ${gasto.price}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _getImagePath(String type) {
    final itemType = types.firstWhere(
      (element) => element["name"] == type,
      orElse: () => {"image": "assets/images/otros.webp"},
    );
    return itemType["image"];
  }
}
