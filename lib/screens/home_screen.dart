import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/model/notes_model.dart';
import 'package:gestor_de_gastos/screens/view_note_screen.dart';
import 'package:gestor_de_gastos/services/database_helper.dart';
import 'package:gestor_de_gastos/screens/add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Gastos> _gastos =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadGastos();
  }



  Future<void> _loadGastos() async{
    final gastos = await _databaseHelper.getGasto();
    setState(() {
      _gastos = gastos;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent[300],
        title: const Text('Control de Gastos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          miCard(),
          ListView.builder(
            itemCount: _gastos.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final gasto = _gastos[index];

              return GestureDetector(
                onTap: ()async{
                  await Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => ViewNoteScreen(gastos: gasto,),
                    ));
                  _loadGastos();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent[100],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2)
                      )
                    ]
                  ),
                  padding: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(gasto.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[900],
                      ),),
                    subtitle: Text(gasto.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text('\$ ${gasto.monto}'),
                  )
                  )
                );
            },

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        await Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => const AddEditNoteScreen(),
        ));
          _loadGastos();
      },
          backgroundColor: Colors.deepPurple[100],
          child: const Icon(Icons.add),
      ),

    );
  }
  Card miCard(){
    return Card(
      elevation: 5,
      shadowColor: Colors.deepPurpleAccent,
      color: Colors.deepPurple[200],
      margin: const EdgeInsets.all(15),
      child: SizedBox(
        width: double.infinity,
        height:180,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
              ),
              Text(
                'Resumen de Gasto Total',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurple[900],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20,),
              Text('',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.deepPurple[900],
                ),
              ),
              const SizedBox( height: 10 )

            ],
          ),
        ),
      ),
    );
  }
}
