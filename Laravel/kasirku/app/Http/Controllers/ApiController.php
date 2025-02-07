<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Product;
use App\Models\TransactionHistory;
use App\Models\User;
use App\Services\UploadImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class ApiController extends Controller
{
    public function register(Request $request){
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required'],
            'password' => 'required',
            'phone' => ['required', 'max:15'],
            'address' => ['required', 'max:150'],
        ]);
        if(User::where('email', $data['email'])->count() != 0){
            return response()->json([
                'status' => false,
                'message' => 'Email sudah terdaftar'
            ]);
        }
        User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'phone' => $data['phone'],
            'address' => $data['address'],
            'password' => Hash::make($data['password']),
        ]);
        return response()->json([
            'status' => true,
            'message' => 'Berhasil mendaftar'
        ]);
    }
    public function login(Request $request){
        $data = $request->validate([
            'email' => 'required',
            'password' => 'required'
        ]);
        $user = User::where('email', $data['email'])->first();
        if(!$user){
            return response()->json([
                'status' => false,
                'message' => 'Data tidak ditemukan!'
            ], 401);
        }
        if(!Hash::check($data['password'], $user->password)){
            return response()->json([
                'status' => false,
                'message' => 'Data tidak ditemukan!'
            ], 401);
        }
        $token = $user->createToken('mobile-access-token', ['*'])->plainTextToken;
        return response()->json([
            'status' => true,
            'message' => 'Data ditemukan!',
            'data' => [
                'token' => $token,
                'user' => $user
            ],
        ], 200);
    }
    public function newProduct(Request $request){
        
        $data = $request->validate([
            'title' => 'required',
            'description' => 'required',
            'price' => 'required',
            'category' => 'required',
            'stock' => 'required',
            'image' => 'image'
        ]);
        
        $image = UploadImage::upload($request->file('image'), 'products');
        $data['photo_url'] = $image['url'];
        
        $user = $request->user();
        $product = $user->products()->create($data);
        return response()->json([
            'status'=> true,
            'message' => 'Berhasil menambahkan data!',
            'data' => [
                'product' => $product
            ]
        ]);
    }
    public function getProducts(Request $request){
        $user = $request->user();
        $products = $user->products;
        return response()->json([
            'status'=> true,
            'message' => 'Berhasil mengambil data!',
            'data' => [
                'products' => $products
            ]
        ]);
    }
    public function editProduct(Request $request){
        $data = $request->validate([
            'title' => 'required',
            'description' => 'required',
            'price' => 'required',
            'category' => 'required',
            'stock' => 'required',
            'photo_url' => 'image'
        ]);
        $image = UploadImage::upload($request->file('image'), 'products');
        $data['photo_url'] = $image['url'];
        $product = Product::find($request->id);
        $product->update($data);
        $product = Product::find($request->id);
        return response()->json([
            'status'=> true,
            'message' => 'Berhasil mengedit data!',
            'data' => [
                'product' => $product
            ]
        ]);
    }
    public function deleteProduct(Request $request){
        $product = Product::find($request->id);

        if ($product) {
            if ($product->photo_url) {
                $imagePath = str_replace(url('/'), '', $product->photo_url);
                $imagePath = base_path('../public_html' . $imagePath);
                
                unlink($imagePath);
            }
    
            $product->delete();
    
            return response()->json([
                'status'=> true,
                'message' => 'Berhasil menghapus data!',
            ]);
        }
    
        return response()->json([
            'status'=> false,
            'message' => 'Produk tidak ditemukan!',
        ], 404);
       
    }
    public function newOrder(Request $request){
        $data = $request->validate([
            'method' => 'required',
            'total' => 'required'
        ]);
        $user = $request->user();
        $order = $user->orders()->create($data);

        $transaction = TransactionHistory::where('user_id', $user->id)
            ->whereMonth('created_at', now())
            ->first();

        if($transaction != null){
            $transaction->total += $order->total;
            $transaction->save();
        }
        else{
            $user->transactionHistories()->create([
                'total' => $order->total
            ]);
        }

        return response()->json([
            'status'=> true,
            'message' => 'Berhasil menambahkan data!',
            'data' => [
                'order' => $order
            ]
        ]);
    }
    public function getOrders(Request $request){
        $user = $request->user();
        $orders = $user->orders()->orderBy('created_at', 'desc')->get()
    ->map(function ($order) {
        $order->created_at = $order->created_at->setTimezone('Asia/Jakarta');
        return $order;
    });
        return response()->json([
            'status'=> true,
            'message' => 'Berhasil mengambil data!',
            'data' => [
                'orders' => $orders
            ]
        ]);
    }
    public function orderItems(Request $request){
        $data = $request->validate([
            'order_id' => 'required',
            'order_items' => ['required', 'array'],
            'order_items.*.product_id' => 'required',
            'order_items.*.price' => 'required',
            'order_items.*.quantity' => 'required',
            'order_items.*.sub_total' => 'required',
        ]);
        $createdOrderItems = [];
        $order = Order::find($data['order_id']);
        foreach($data['order_items'] as $item){
            $createdOrderItems[] = $order->orderItems()->create($item);
        }
        return response()->json([
            'status'=> true,
            'message' => 'Berhasil menambahkan data!',
            'data' => [
                'orderItems' => $createdOrderItems
            ]
        ]);
    }
    public function getOrderItems(Request $request){
        $user = $request->user();
        $orders = $user->orders;
        $orderItems = [];
        foreach($orders as $order){
            foreach($order->orderItems as $item){
                $orderItems[] = $item;
            }
        }
        return response()->json([
            'status'=> true,
            'message' => 'Berhasil mengambil data!',
            'data' => [
                'order_items' => $orderItems
            ]
        ]);
    }
    public function getTransactions(Request $request){
        $user = $request->user();
        $transaction = $user->transactionHistories;
        return response()->json([
            'status'=> true,
            'message' => 'Berhasil mengambil data!',
            'data' => [
                'transactions' => $transaction
            ]
        ]);
    }
}
