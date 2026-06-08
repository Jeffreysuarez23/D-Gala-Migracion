<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Direccion;

class DireccionController extends Controller
{
    // Listar todas las direcciones
    public function index()
    {
        return response()->json(
            Direccion::all()
        );
    }

    // Crear dirección
    public function store(Request $request)
    {
        $direccion = Direccion::create([
            'usuario_id' => $request->usuario_id,
            'nombre_recibe' => $request->nombre_recibe,
            'telefono' => $request->telefono,
            'departamento' => $request->departamento,
            'ciudad' => $request->ciudad,
            'direccion' => $request->direccion,
            'referencia' => $request->referencia,
            'codigo_postal' => $request->codigo_postal,
            'principal' => $request->principal ?? 0
        ]);

        return response()->json([
            'message' => 'Dirección creada correctamente',
            'data' => $direccion
        ], 201);
    }

    // Ver una dirección
    public function show($id)
    {
        $direccion = Direccion::find($id);

        if (!$direccion) {
            return response()->json([
                'message' => 'Dirección no encontrada'
            ], 404);
        }

        return response()->json($direccion);
    }

    // Actualizar dirección
    public function update(Request $request, $id)
    {
        $direccion = Direccion::find($id);

        if (!$direccion) {
            return response()->json([
                'message' => 'Dirección no encontrada'
            ], 404);
        }

        $direccion->update($request->all());

        return response()->json([
            'message' => 'Dirección actualizada correctamente',
            'data' => $direccion
        ]);
    }

    // Eliminar dirección
    public function destroy($id)
    {
        $direccion = Direccion::find($id);

        if (!$direccion) {
            return response()->json([
                'message' => 'Dirección no encontrada'
            ], 404);
        }

        $direccion->delete();

        return response()->json([
            'message' => 'Dirección eliminada correctamente'
        ]);
    }
}