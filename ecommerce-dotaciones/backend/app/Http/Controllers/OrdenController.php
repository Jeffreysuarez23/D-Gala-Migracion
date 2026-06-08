<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Carrito;
use App\Models\Orden;
use App\Models\OrdenItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OrdenController extends Controller
{
    public function crearDesdeCarrito(Request $request)
    {
        $request->validate([
            'carrito_id' => 'required|exists:carritos,id',
            'usuario_id' => 'required|exists:usuarios,id',
            'direccion_id' => 'required|exists:direcciones,id',
        ]);

        DB::beginTransaction();

        try {

            $carrito = Carrito::with('items.variante.producto')
                ->findOrFail($request->carrito_id);

            if ($carrito->items->count() == 0) {
                return response()->json([
                    'message' => 'El carrito está vacío'
                ], 400);
            }

            $subtotal = 0;

            foreach ($carrito->items as $item) {
                $precio = $item->variante->producto->precio_minorista
                    + $item->variante->precio_extra;

                $subtotal += ($precio * $item->cantidad);
            }

            $orden = Orden::create([
                'usuario_id' => $request->usuario_id,
                'direccion_id' => $request->direccion_id,
                'numero' => 'ORD-' . time(),
                'estado' => 'pendiente',
                'tipo_precio' => 'minorista',
                'subtotal' => $subtotal,
                'descuento' => 0,
                'envio_costo' => 0,
                'total' => $subtotal
            ]);

            foreach ($carrito->items as $item) {
                $precio = $item->variante->producto->precio_minorista
                    + $item->variante->precio_extra;

                OrdenItem::create([
                    'orden_id' => $orden->id,
                    'variante_id' => $item->variante_id,
                    'lona_id_snapshot' => $item->lona_id,
                    'cantidad' => $item->cantidad,
                    'precio_unitario' => $precio,
                    'total_linea' => $precio * $item->cantidad
                ]);
            }

            // vaciar carrito
            $carrito->items()->delete();

            DB::commit();

            return response()->json([
                'message' => 'Orden creada correctamente',
                'data' => $orden
            ], 201);

        } catch (\Exception $e) {

            DB::rollBack();

            return response()->json([
                'message' => 'Error al crear orden',
                'error' => $e->getMessage()
            ], 500);
        }
    }
        // LISTAR ORDENES
    public function index()
    {
        $ordenes = Orden::with([
            'items.variante.producto',
            'direccion',
            'usuario',
            'envio'
        ])->get();

        return response()->json([
            'message' => 'Listado de órdenes',
            'data' => $ordenes
        ]);
    }

    // VER DETALLE ORDEN
    public function show($id)
    {
        $orden = Orden::with([
            'items.variante.producto',
            'direccion',
            'usuario',
            'envio'
        ])->find($id);

        if (!$orden) {
            return response()->json([
                'message' => 'Orden no encontrada'
            ], 404);
        }

        return response()->json([
            'message' => 'Detalle de orden',
            'data' => $orden
        ]);
    }

    // CAMBIAR ESTADO
    public function cambiarEstado(Request $request, $id)
    {
        $request->validate([
           'estado' => 'required|in:pendiente,confirmada,procesando,enviado,entregado,cancelada,devuelta'
        ]);

        $orden = Orden::find($id);

        if (!$orden) {
            return response()->json([
                'message' => 'Orden no encontrada'
            ], 404);
        }

        $orden->estado = $request->estado;
        $orden->save();

        return response()->json([
            'message' => 'Estado actualizado correctamente',
            'data' => $orden
        ]);
    }

    // CANCELAR ORDEN
    public function cancelar($id)
    {
        $orden = Orden::find($id);

        if (!$orden) {
            return response()->json([
                'message' => 'Orden no encontrada'
            ], 404);
        }

        $orden->estado = 'cancelada';
        $orden->save();

        return response()->json([
            'message' => 'Orden cancelada correctamente',
            'data' => $orden
        ]);
    }
    
}