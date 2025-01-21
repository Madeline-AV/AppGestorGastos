
class Gastos{
  final int? id;
  final String titulo;
  final String descripcion;
  final String categorias;
  final String monto;
  final String fecha;

  Gastos({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categorias,
    required this.monto,
    required this.fecha,
});

  Map<String, dynamic> toMap(){
   return{
     'id' : id,
     'titulo' : titulo,
     'descripcion' : descripcion,
     'categorias' : categorias,
     'monto' : monto,
     'fecha' : fecha,
   };
  }

  factory Gastos.fromMap(Map<String, dynamic> map){
    return Gastos(
      id: map['id'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      categorias: map['categorias'],
      monto: map['monto'],
      fecha: map['fecha'],
        );
  }
}