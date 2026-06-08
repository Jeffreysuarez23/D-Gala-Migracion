<?php
namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Productos;
use Illuminate\Support\Str;



// CONTROLADOR DE PRODUCTOS QUE PERMITE CREAR, LISTAR, MOSTRAR DETALLES, ACTUALIZAR Y ELIMINAR PRODUCTOS. CADA PRODUCTO TIENE UN NOMBRE, PRECIOS PARA MINORISTA Y MAYORISTA, Y UNA RELACIÓN CON VARIANTES (COMO COLOR O TALLA).
class ProductController extends Controller
{
    // CREAR UN NUEVO PRODUCTO
    public function store(Request $request)
    {
        $request->validate([
            'nombre' => 'required|string|max:150',
            'precio_minorista' => 'required|numeric|min:0',
            'precio_mayorista' => 'required|numeric|min:0',
            'min_cantidad_mayorista' => 'nullable|integer|min:1'
        ]);

        $producto = Productos::create([
            'nombre' => $request->nombre,
            'slug' => Str::slug($request->nombre),
            'precio_minorista' => $request->precio_minorista,
            'precio_mayorista' => $request->precio_mayorista,
            'min_cantidad_mayorista' => $request->min_cantidad_mayorista ?? 12,
            'publicado' => 1
        ]);

        return response()->json($producto, 201);
    }
 // LISTAR TODOS LOS PRODUCTOS
    public function index()
    {
        return Productos::all();
    }
 //  MOSTRAR UN PRODUCTO CON SUS VARIANTES
    public function show($id)
    {
        $producto = Productos::with('variantes')->findOrFail($id);

        return response()->json([
            'id' => $producto->id,
            'nombre' => $producto->nombre,
            'precio_minorista' => $producto->precio_minorista,
            'precio_mayorista' => $producto->precio_mayorista,
            'variantes' => $producto->variantes->map(function ($v) {
                return [
                    'id' => $v->id,
                    'sku' => $v->sku,
                    'color' => $v->color,
                    'talla' => $v->talla,
                    'stock' => $v->stock,
                    'precio_extra' => $v->precio_extra
                ];
            })
        ]);
    }
    // ACTUALIZAR UN PRODUCTO EXISTENTE
public function update(Request $request, $id)
{
    $producto = Productos::findOrFail($id);

    $validated = $request->validate([
        'nombre' => 'sometimes|string|max:150',
        'precio_minorista' => 'sometimes|numeric|min:0',
        'precio_mayorista' => 'sometimes|numeric|min:0',
        'min_cantidad_mayorista' => 'nullable|integer|min:1'
    ]);

    if(isset($validated['nombre'])){
        $validated['slug'] = Str::slug($validated['nombre']);
    }

    $producto->update($validated);

    return response()->json([
        'message' => 'Producto actualizado',
        'data' => $producto
    ]);
}


//  ELIMINAR UN PRODUCTO
public function destroy($id)
{
    $producto = Productos::findOrFail($id);

    $producto->delete();

    return response()->json([
        'message' => 'Producto eliminado'
    ]);
}
}