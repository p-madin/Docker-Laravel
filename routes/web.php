<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

// Conditionally load auth routes to prevent crashes during the initial 
// Docker startup before `breeze:install` has generated the controllers.
if (file_exists(__DIR__.'/auth.php') && file_exists(app_path('Http/Controllers/Auth/AuthenticatedSessionController.php'))) {
    require __DIR__.'/auth.php';
}
