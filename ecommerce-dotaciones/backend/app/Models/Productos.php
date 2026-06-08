<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
use App\Models\VarianteProducto;

// MODELO DE PRODUCTOS
class Productos extends Model
{
    protected $table = 'productos';

    public $timestamps = false;

    protected $fillable = [
        'nombre',
        'slug',
        'precio_minorista',
        'precio_mayorista',
        'min_cantidad_mayorista',
        'publicado'
    ];
    
    // RELACIÓN CON VARIANTES DE PRODUCTO
    public function variantes()
    {
        return $this->hasMany(VarianteProducto::class, 'producto_id');
    }
}
