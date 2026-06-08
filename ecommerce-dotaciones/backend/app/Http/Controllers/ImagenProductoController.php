<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\ImagenProducto;


// CONTROLADOR DE IMÁGENES DE PRODUCTOS
class ImagenProductoController extends Controller
{
    // LISTAR IMÁGENES DE UN PRODUCTO
    public function index($producto_id)
    {
        $imagenes = ImagenProducto::where('producto_id', $producto_id)->get();
        return response()->json($imagenes);
    }

    // CREAR IMAGEN
    public function store(Request $request)
    {
        $validated = $request->validate([
            'producto_id' => 'required|integer|exists:productos,id',
            'variante_id' => 'nullable|integer|exists:variantes_producto,id',
            'url' => 'required|string|max:500',
            'es_portada' => 'nullable|boolean',
            'orden' => 'nullable|integer|min:0'
        ]);

        // VALORES POR DEFECTO
        $validated['es_portada'] = $validated['es_portada'] ?? 0;
        $validated['orden'] = $validated['orden'] ?? 0;

        // SI ES PORTADA → DESMARCAR OTRAS IMÁGENES COMO PORTADA
        if ($validated['es_portada']) {
            ImagenProducto::where('producto_id', $validated['producto_id'])
                ->update(['es_portada' => 0]);
        }

        $imagen = ImagenProducto::create($validated);

        return response()->json([
            'message' => 'Imagen creada correctamente',
            'data' => $imagen
        ], 201);
    }

    // ACTUALIZAR IMAGEN
        public function update(Request $request, $id)
        {
            $imagen = ImagenProducto::findOrFail($id);

            $validated = $request->validate([
                'url' => 'sometimes|string|max:500',
                'es_portada' => 'nullable|boolean',
                'orden' => 'nullable|integer|min:0'
            ]);

            // si esta imagen será portada → quitar portada a las demás
            if (isset($validated['es_portada']) && $validated['es_portada'] == 1) {
                ImagenProducto::where('producto_id', $imagen->producto_id)
                    ->update(['es_portada' => 0]);
            }

            $imagen->update($validated);

            return response()->json([
                'message' => 'Imagen actualizada',
                'data' => $imagen
            ]);
        }

    //  ELIMINAR IMAGEN
    public function destroy($id)
    {
        $imagen = ImagenProducto::findOrFail($id);
        $imagen->delete();

        return response()->json([
            'message' => 'Imagen eliminada'
        ]);
    }
}