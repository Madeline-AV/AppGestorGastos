import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/model/notes_model.dart';
import 'package:gestor_de_gastos/screens/add_edit_screen.dart';
import 'package:gestor_de_gastos/services/database_helper.dart';

class ViewNoteScreen extends StatelessWidget {
  final Gastos gastos;
  ViewNoteScreen({required this.gastos});

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        elevation: 0,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new),
        color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: ()async{
                await Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => AddEditNoteScreen(
                      gastos: gastos,)));
              },
             icon: const Icon(
             Icons.edit,
             color: Colors.white,
      ),),
          IconButton(
            onPressed: ()=> _showDeleteDialog(context),
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            )),
          const SizedBox(width: 8,
          )
        ],
      ),
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gastos.titulo,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12,),
            ],
          ),),
          Expanded(child: Container(width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent[100],
            borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )
          ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Text(
                    gastos.descripcion,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  const Text("Categoria:",
                  style: TextStyle(
                    fontSize: 20,
                      fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),),
                  const SizedBox(height: 5,),
                  Text(
                    gastos.categorias,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  const Text("Monto:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),),
                  const SizedBox(height: 5,),
                  Text(
                    gastos.monto,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  const Text("Fecha:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),),
                  const SizedBox(height: 5,),
                  Text(
                    gastos.fecha,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),


                ],
              ),


            ),
          ))
        ],
      )),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async{
    final confirm = await showDialog(context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Eliminar Gasto',
          style: TextStyle(fontWeight: FontWeight.bold),),
          content: const Text('Seguro que que quieres eliminar este gasto?',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
          ),),
          actions: [
            TextButton(onPressed: ()=>Navigator.pop(context, false),
                child: Text('Cancelar',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
                )),
            TextButton(onPressed: ()=>Navigator.pop(context, true),
                child: const Text('Eliminar',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),))
          ],
        ));
    if(confirm == true){
      await _databaseHelper.Deletegasto(gastos.id!);
      Navigator.pop(context);
    }
  }
}
