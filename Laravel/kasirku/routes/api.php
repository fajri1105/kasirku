<?php

use App\Http\Controllers\ApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/register', [ApiController::class, 'register']);
Route::post('/login', [ApiController::class, 'login']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/product', [ApiController::class, 'newProduct']);
    Route::get('/products', [ApiController::class, 'getProducts']);
    Route::put('/product/{id}', [ApiController::class, 'editProduct']);
    Route::delete('/product/{id}', [ApiController::class, 'deleteProduct']);

    Route::post('/order', [ApiController::class, 'newOrder']);
    Route::get('/orders', [ApiController::class, 'getOrders']);

    Route::get('/transaction', [ApiController::class, 'getTransactions']);

    Route::post('/order-items', [ApiController::class, 'orderItems']);
    Route::get('/order-items', [ApiController::class, 'getOrderItems']);
});
