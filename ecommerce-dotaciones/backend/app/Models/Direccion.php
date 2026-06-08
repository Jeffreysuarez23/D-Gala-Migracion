<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;


// DIRECCIONES
class Direccion extends Model
{
    protected $table = 'direcciones';

    public $timestamps = false;

    protected $fillable = [
        'usuario_id',
        'nombre_recibe',
        'telefono',
        'departamento',
        'ciudad',
        'direccion',
        'referencia',
        'codigo_postal',
        'principal'
    ];
}