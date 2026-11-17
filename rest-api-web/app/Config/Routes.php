<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */

$routes->options('(:any)', static function () {
    return response()->setStatusCode(204);
});

$routes->get('/', 'Home::index');

// Routes under /api/umkm (as in the module)
$routes->group('api', function($routes) {
    $routes->get('umkm', '\App\Controllers\Api\UmkmController::index');
    $routes->get('umkm/(:num)', '\App\Controllers\Api\UmkmController::show/$1');
    $routes->post('umkm', '\App\Controllers\Api\UmkmController::create');
    $routes->put('umkm/(:num)', '\App\Controllers\Api\UmkmController::update/$1');
    $routes->delete('umkm/(:num)', '\App\Controllers\Api\UmkmController::delete/$1');
});

// Also support direct /umkm routes as mentioned in prompt (e.g., GET /umkm, POST /umkm, PUT /umkm/{id}, DELETE /umkm/{id})
$routes->get('umkm', '\App\Controllers\Api\UmkmController::index');
$routes->get('umkm/(:num)', '\App\Controllers\Api\UmkmController::show/$1');
$routes->post('umkm', '\App\Controllers\Api\UmkmController::create');
$routes->put('umkm/(:num)', '\App\Controllers\Api\UmkmController::update/$1');
$routes->delete('umkm/(:num)', '\App\Controllers\Api\UmkmController::delete/$1');
