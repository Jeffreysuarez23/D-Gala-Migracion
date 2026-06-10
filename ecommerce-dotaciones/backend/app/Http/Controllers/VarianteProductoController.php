<?php
namespace App\Http\Controllers;
use App\Models\VarianteProducto;
use App\Models\Lona;
use Illuminate\Http\Request;

// CONTROLADOR DE VARIANTES DE PRODUCTO QUE PERMITE CREAR, ACTUALIZAR Y ELIMINAR LAS VARIANTES ASOCIADAS A UN PRODUCTO. LAS VARIANTES PUEDEN INCLUIR UNA LONA ASOCIADA, SKU, COLOR, TALLA, STOCK Y PRECIO EXTRA.
class VarianteProductoController extends Controller
{
    // CREAR NUEVA VARIANTE
    public function store(Request $request)
    {
        $validated = $request->validate([
            'producto_id' => 'required|integer|exists:productos,id',
            'lona_id' => 'nullable|integer|exists:lonas,id',
            'sku' => 'nullable|string|max:100',
            'color' => 'required|string|max:50',
            'color_hex' => 'nullable|string|max:20',
            'talla' => 'required|string|max:10',
            'stock' => 'nullable|integer|min:0',
            'precio_extra' => 'nullable|numeric|min:0',
            'descuento' => 'nullable|integer|min:0|max:100'
        ]);

        try {
            // Si no se proporciona stock, establecer a 0
            if (!isset($validated['stock'])) {
                $validated['stock'] = 0;
            }

            $variante = VarianteProducto::create($validated);

            return response()->json([
                'message' => 'Variante creada correctamente',
                'data' => $variante
            ], 201);

        } catch (\Illuminate\Database\QueryException $e) {
            return response()->json([
                'error' => 'Error al crear la variante. Verifica los datos.',
                'details' => $e->getMessage()
            ], 400);
        }
    }

    // ACTUALIZAR
public function update(Request $request, $id)
{
    $variante = VarianteProducto::findOrFail($id);

    $validated = $request->validate([
        'lona_id' => 'nullable|integer|exists:lonas,id',
        'sku' => 'nullable|string|max:100',
        'color' => 'sometimes|string|max:50',
        'color_hex' => 'nullable|string|max:20',
        'talla' => 'sometimes|string|max:10',
        'stock' => 'nullable|integer|min:0',
        'precio_extra' => 'nullable|numeric|min:0',
        'descuento' => 'nullable|integer|min:0|max:100'
    ]);

    $variante->update($validated);

    return response()->json([
        'message' => 'Variante actualizada',
        'data' => $variante
    ]);
}


// ELIMINAR
public function destroy($id)
{
    $variante = VarianteProducto::findOrFail($id);

    $variante->delete();

    return response()->json([
        'message' => 'Variante eliminada'
    ]);
}
}