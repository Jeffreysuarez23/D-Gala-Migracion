<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

// LONAS
class Lona extends Model
{
    protected $table = 'lonas';

    public $timestamps = false;

    protected $fillable = [
        'dotacion_id',
        'codigo',
        'tipo_producto',
        'categoria',
        'color',
        'estado',
        'activa'
    ];
}