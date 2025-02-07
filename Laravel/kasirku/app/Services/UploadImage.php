<?php

namespace App\Services;

use Anakadote\ImageManager\Facades\ImageManager;
use Illuminate\Support\Facades\Http;

class UploadImage{
    static public function upload($image, $folder){
        $originalPath = $image->getRealPath();
        $newFileName = uniqid() . '.webp';
        $destinationPath = public_path('images/products/');
        $processedImagePath = ImageManager::getImagePath(
            $originalPath,
            500,              // Lebar (ukuran output maksimal, bisa disesuaikan)
            500,              // Tinggi (menjaga rasio 1:1)
            'crop',           // Mode crop dari tengah
            80,               // Kualitas (0-100)
            'webp'            // Format output
        );

        $success = copy($processedImagePath, $destinationPath . $newFileName);

        if ($success) {
            return [
                'status' => true,
                'url' => asset('images/'. $folder . '/' . $newFileName),
            ];
        } else {
            return [
                'status' => false,
                'url' => null
            ];
        }
    }
}
