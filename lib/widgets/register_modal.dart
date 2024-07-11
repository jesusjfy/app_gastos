import 'package:flutter/material.dart';
import 'package:gastosappg8/db/db_admin.dart';
import 'package:gastosappg8/models/gasto_model.dart';
import 'package:gastosappg8/utils/data_general.dart';
import 'package:gastosappg8/widgets/field_modal_widget.dart';
import 'package:gastosappg8/widgets/item_type_widget.dart';

class RegisterModal extends StatefulWidget {
  final GastoModel? gasto;

  RegisterModal({this.gasto});

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String typeSelected = "Alimentos";

  @override
  void initState() {
    super.initState();
    if (widget.gasto != null) {
      _productController.text = widget.gasto!.title;
      _priceController.text = widget.gasto!.price.toString();
      _dateController.text = widget.gasto!.datetime;
      typeSelected = widget.gasto!.type;
    }
  }

  @override
  void dispose() {
    _productController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _showDateTimePicker() async {
    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            colorScheme: ColorScheme.light(primary: Colors.black),
          ),
          child: child!,
        );
      },
    );
    if (datePicker != null) {
      _dateController.text = datePicker.toString();
    }
  }

  Future<void> _addOrUpdateGasto() async {
    if (_productController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text("Todos los campos son obligatorios"),
        ),
      );
      return;
    }

    GastoModel gasto = GastoModel(
      id: 0,
      title: _productController.text,
      price: double.parse(_priceController.text),
      datetime: _dateController.text,
      type: typeSelected,
    );

    int value;
    if (widget.gasto == null) {
      value = await DBAdmin().insertarGasto(gasto);
    } else {
      value = await DBAdmin().actualizarGasto(widget.gasto!.id, gasto);
    }

    if (value > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.cyan,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(widget.gasto == null
              ? "Se ha registrado correctamente"
              : "Se ha actualizado correctamente"),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _deleteGasto() async {
    if (widget.gasto != null) {
      int value = await DBAdmin().eliminarGasto(widget.gasto!.id);
      if (value > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.cyan,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Text("Se ha eliminado correctamente"),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Registra el gasto",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            FieldModalWidget(
              hint: "Ingresa el título",
              controller: _productController,
            ),
            FieldModalWidget(
              hint: "Ingresa el monto",
              controller: _priceController,
              isNumberKeryboard: true,
            ),
            FieldModalWidget(
              hint: "Selecciona una fecha",
              controller: _dateController,
              isDatePicker: true,
              function: _showDateTimePicker,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: types.map((e) {
                  return ItemTypeWidget(
                    data: e,
                    isSelected: e["name"] == typeSelected,
                    tap: () {
                      setState(() {
                        typeSelected = e["name"];
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _addOrUpdateGasto,
                child: Text(widget.gasto == null ? "Añadir" : "Actualizar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            if (widget.gasto != null)
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _deleteGasto,
                  child: Text("Eliminar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
