<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Lona;

// CONTROLADOR PARA GESTIONAR LAS LONAS, QUE SON UNA SUBCATEGORÍA DE PRODUCTOS ASOCIADOS A DOTACIONES. PERMITE CREAR, LISTAR, ACTUALIZAR Y DESACTIVAR (SOFT DELETE) LAS LONAS.
class LonaController extends Controller
{
    //  LISTAR TODAS
    public function index()
    {
        $lonas = Lona::orderBy('id', 'desc')->get();

        return response()->json($lonas);
    }

    //  CREAR
    public function store(Request $request)
    {
        $validated = $request->validate([
            'dotacion_id' => 'required|exists:dotaciones,id',
            'codigo' => 'required|string|max:50|unique:lonas,codigo',
            'tipo_producto' => 'nullable|string|max:80',
            'categoria' => 'nullable|string|max:80',
            'color' => 'nullable|string|max:50',
            'estado' => 'nullable|in:nuevo,usado'
        ]);

        $validated['estado'] = $validated['estado'] ?? 'nuevo';
        $validated['activa'] = 1;

        $lona = Lona::create($validated);

        return response()->json([
            'message' => 'Lona creada correctamente',
            'data' => $lona
        ], 201);
    }

    //  VER UNA
    public function show($id)
    {
        $lona = Lona::findOrFail($id);

        return response()->json($lona);
    }

    //  ACTUALIZAR
    public function update(Request $request, $id)
    {
        $lona = Lona::findOrFail($id);

        $validated = $request->validate([
            'tipo_producto' => 'nullable|string|max:80',
            'categoria' => 'nullable|string|max:80',
            'color' => 'nullable|string|max:50',
            'estado' => 'nullable|in:nuevo,usado'
        ]);

        $lona->update($validated);

        return response()->json([
            'message' => 'Lona actualizada',
            'data' => $lona
        ]);
    }

    //  DESACTIVAR (soft)
    public function destroy($id)
    {
        $lona = Lona::findOrFail($id);

        $lona->activa = 0;
        $lona->save();

        return response()->json([
            'message' => 'Lona desactivada'
        ]);
    }
}