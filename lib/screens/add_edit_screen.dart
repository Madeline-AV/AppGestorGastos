import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/model/notes_model.dart';
import 'package:gestor_de_gastos/screens/home_screen.dart';
import 'package:gestor_de_gastos/services/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Gastos? gastos;
  const AddEditNoteScreen({this.gastos});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _categoriasController = TextEditingController();
  final _montoController = TextEditingController();
  final _fechaController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.gastos!= null){
      _tituloController.text = widget.gastos!.titulo;
      _descripcionController.text = widget.gastos!.descripcion;
      _categoriasController.text = widget.gastos!.categorias;
      _montoController.text = widget.gastos!.monto;
      _fechaController.text = widget.gastos!.fecha;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent[100],
        title: Text(widget.gastos != null ? "Agregar Gasto" : "Editar Gasto"),
      ),
      body: Form(
        key: _formKey,
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(15)),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: _tituloController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15)
                          )
                      ),
                      labelText: 'Titulo',
                      hintText: 'Ejem: Alquiler'

                  ),
                  validator: (String? value){
                    if(value == null || value.isEmpty){
                      return "Campo requerido";
                    }
                    return null;
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: _descripcionController,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15)
                          )
                      ),
                      labelText: 'Descripción',
                      hintText: "Ejem: El proximo ser mas anticipado..."
                  ),
                  validator: (String? value){
                    if(value == null || value.isEmpty){
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: _categoriasController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(15)
                        )
                    ),
                    hintText: "Ejem: Hogar, Salud, Comida, etc.",
                    labelText: 'Categoria',
                  ),
                  validator: (String? value){
                    if(value == null || value.isEmpty){
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: _montoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(15)
                        )
                    ),
                    labelText: 'Monto',
                  ),

                  onChanged: (string) {
                    string = formNum(
                      string.replaceAll(',',''),
                    );
                    _montoController.value = TextEditingValue(
                      text: string,
                      selection: TextSelection.collapsed(
                        offset: string.length,
                      ),
                    );
                  },
                  validator: (String? value){
                    if(value == null || value.isEmpty){
                      return 'Campo requerido';
                    }
                    return null;
                  },

                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: _fechaController,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: "##/##/####",
                      filter: {
                        '#' : RegExp(r'\d+|-|/'),
                      },
                    )
                  ],
                  maxLength: 8,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15)
                          )
                      ),
                      labelText: 'Fecha',
                      hintText: "DD/MM/YYYY"

                  ),
                  validator: (String? value){
                    if(value == null || value.isEmpty){
                      return 'Campo requerido';
                    }
                    return null;
                  },

                ),
              ),

              InkWell(
                onTap: (){
                  _saveGastos();
                  Navigator.push(context, MaterialPageRoute(builder:(context) => HomeScreen(),));
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(
                    child: Text(
                      'Guardar Gasto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
      )
    );
  }

  Future<void> _saveGastos() async{
    if(_formKey.currentState!.validate()){
      final gastos = Gastos(
        id: widget.gastos?.id,
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        categorias: _categoriasController.text,
        monto: _montoController.text,
        fecha: _fechaController.text.toString(),
      );

      if(widget.gastos == null){
        await _databaseHelper.inserGasto(gastos);
      }else{
        await _databaseHelper.Updategasto(gastos);
      }
    }
  }
}
