import 'package:brasil_fields/brasil_fields.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:puc_minas/app/core/models/product_model.dart';
import 'package:validatorless/validatorless.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final colorEC = TextEditingController();
  final descriptionEC = TextEditingController();
  final priceEC = TextEditingController();

  Color selectedcolor = Colors.redAccent;
  String size = 'M';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Produto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: Validatorless.required('Campo obrigatório'),
                  controller: descriptionEC,
                  decoration: const InputDecoration(hintText: 'Descrição do Produto'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true),
                  ],
                  validator: Validatorless.multiple([Validatorless.required('Campo obrigatório')]),
                  controller: priceEC,
                  decoration: const InputDecoration(hintText: 'Preço'),
                ),
                const SizedBox(height: 10),
                CustomRadioButton(
                  buttonLables: const ['Pequeno', 'Médio', 'Grande'],
                  buttonValues: const ['P', 'M', 'G'],
                  radioButtonValue: (str) {
                    size = str;
                  },
                  unSelectedColor: Colors.white,
                  selectedColor: Colors.green,
                  shapeRadius: 10,
                  enableShape: true,
                  enableButtonWrap: true,
                  elevation: 5,
                  defaultSelected: size,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    await showColorPickerDialog(
                      context,
                      selectedcolor,
                      actionButtons: const ColorPickerActionButtons(closeButton: true),
                      barrierDismissible: false,
                      barrierColor: Colors.black.withOpacity(0.7),
                      backgroundColor: Colors.white,
                      pickersEnabled: {
                        ColorPickerType.primary: true,
                        ColorPickerType.accent: false,
                        ColorPickerType.wheel: true,
                      },
                      pickerTypeLabels: {
                        ColorPickerType.primary: 'Cor Primária',
                        ColorPickerType.wheel: 'Cromático',
                      },
                      elevation: 2,
                      title: Text('Selecione a cor do produto'),
                      runSpacing: 15,
                      spacing: 15,
                    ).then((color) {
                      selectedcolor = color;
                      setState(() {});
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 105, 102, 102)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Selecioe a cor'),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(color: selectedcolor, borderRadius: BorderRadius.circular(50)),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          ProductModel product = ProductModel(size: size, price: priceEC.text, color: selectedcolor, descriptions: descriptionEC.text);

                          Navigator.of(context).pop(product);
                        }
                      },
                      child: Text('CADASTRAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, decoration: TextDecoration.underline, decorationColor: Colors.white)),
                    ))
              ],
            ).animate().slideY(begin: 2, end: 0, duration: 500.ms),
          ),
        ),
      ),
    );
  }
}
