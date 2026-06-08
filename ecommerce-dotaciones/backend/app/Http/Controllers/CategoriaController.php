<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Categoria;
use Illuminate\Support\Str;

// CONTROLADOR PARA GESTIONAR LAS CATEGORÍAS DE PRODUCTOS. PERMITE CREAR, LISTAR, ACTUALIZAR Y ELIMINAR CATEGORÍAS. LAS CATEGORÍAS PUEDEN SER PADRE O HIJO (SUBCATEGORÍA) Y SE ORDENAN POR UN CAMPO "ORDEN".
class CategoriaController extends Controller
{
    // LISTAR 
    public function index()
    {
        $categorias = Categoria::whereNull('padre_id')
            ->with('hijos')
            ->orderBy('orden')
            ->get();

        return response()->json($categorias);
    }

    //  CREAR
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nombre' => 'required|string|max:100',
            'padre_id' => 'nullable|integer|exists:categorias,id',
            'orden' => 'nullable|integer|min:0'
        ]);

        $validated['slug'] = Str::slug($validated['nombre']);
        $validated['orden'] = $validated['orden'] ?? 0;

        $categoria = Categoria::create($validated);

        return response()->json([
            'message' => 'Categoría creada',
            'data' => $categoria
        ], 201);
    }

    //  VER UNA
    public function show($id)
    {
        $categoria = Categoria::with('hijos')->findOrFail($id);

        return response()->json($categoria);
    }

    //  ACTUALIZAR
    public function update(Request $request, $id)
    {
        $categoria = Categoria::findOrFail($id);

        $validated = $request->validate([
            'nombre' => 'sometimes|string|max:100',
            'padre_id' => 'nullable|integer|exists:categorias,id',
            'orden' => 'nullable|integer|min:0'
        ]);

        if (isset($validated['nombre'])) {
            $validated['slug'] = Str::slug($validated['nombre']);
        }

        $categoria->update($validated);

        return response()->json([
            'message' => 'Categoría actualizada',
            'data' => $categoria
        ]);
    }

    //  ELIMINAR
    public function destroy($id)
    {
        $categoria = Categoria::findOrFail($id);

        //  Validar que no tenga hijos
        if ($categoria->hijos()->count() > 0) {
            return response()->json([
                'message' => 'No puedes eliminar una categoría con subcategorías'
            ], 400);
        }

        $categoria->delete();

        return response()->json([
            'message' => 'Categoría eliminada'
        ]);
    }
}