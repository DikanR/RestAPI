<?php

namespace App\Controllers\Api;

use App\Models\UmkmModel;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\RESTful\ResourceController;

class UmkmController extends ResourceController
{
    protected $modelName = 'App\Models\UmkmModel';
    protected $format    = 'json';

    // 1. GET /umkm or /api/umkm (Read all)
    public function index()
    {
        $umkmModel = new UmkmModel();
        $umkm = $umkmModel->findAll();

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diambil',
            'data'    => $umkm,
        ], 200);
    }

    // 2. GET /umkm/{id} or /api/umkm/{id} (Read single)
    public function show($id = null)
    {
        $umkmModel = new UmkmModel();
        $umkm = $umkmModel->find($id);

        if (!$umkm) {
            return $this->respond([
                'success' => false,
                'message' => 'Data UMKM tidak ditemukan',
                'errors'  => null,
            ], 404);
        }

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diambil',
            'data'    => $umkm,
        ], 200);
    }

    // 3. POST /umkm or /api/umkm (Create)
    public function create()
    {
        $validation = \Config\Services::validation();

        $rules = [
            'nama_umkm' => [
                'rules'  => 'required',
                'errors' => [
                    'required' => 'Nama UMKM wajib diisi',
                ],
            ],
            'kategori'  => [
                'rules'  => 'permit_empty|string',
                'errors' => [
                    'string' => 'Kategori tidak valid',
                ],
            ],
            'pemilik'   => 'permit_empty|string',
            'alamat'    => 'permit_empty|string',
            'kontak'    => 'permit_empty|string',
        ];

        // Support both json payload and form-data/x-www-form-urlencoded
        $data = $this->request->getJSON(true) ?? $this->request->getPost();

        if (!$validation->setRules($rules)->run($data)) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal menambahkan data UMKM',
                'errors'  => $validation->getErrors(),
            ], 400);
        }

        $umkmModel = new UmkmModel();
        $insertedId = $umkmModel->insert([
            'nama_umkm' => $data['nama_umkm'] ?? '',
            'pemilik'   => $data['pemilik'] ?? '',
            'alamat'    => $data['alamat'] ?? '',
            'kategori'  => $data['kategori'] ?? '',
            'kontak'    => $data['kontak'] ?? '',
        ]);

        if ($insertedId === false) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal menambahkan data UMKM',
                'errors'  => $umkmModel->errors(),
            ], 500);
        }

        $newData = $umkmModel->find($insertedId);

        return $this->respondCreated([
            'success' => true,
            'message' => 'Data UMKM berhasil ditambahkan',
            'data'    => $newData,
        ]);
    }

    // 4. PUT /umkm/{id} or /api/umkm/{id} (Update)
    public function update($id = null)
    {
        $umkmModel = new UmkmModel();
        $existing = $umkmModel->find($id);

        if (!$existing) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal memperbarui data UMKM',
                'errors'  => [
                    'id' => 'Data UMKM tidak ditemukan',
                ],
            ], 404);
        }

        $validation = \Config\Services::validation();

        $rules = [
            'nama_umkm' => [
                'rules'  => 'required',
                'errors' => [
                    'required' => 'Nama UMKM wajib diisi',
                ],
            ],
            'kategori'  => [
                'rules'  => 'permit_empty|string',
                'errors' => [
                    'string' => 'Kategori tidak valid',
                ],
            ],
            'pemilik'   => 'permit_empty|string',
            'alamat'    => 'permit_empty|string',
            'kontak'    => 'permit_empty|string',
        ];

        // getRawInput() for PUT x-www-form-urlencoded or getJSON() for JSON
        $data = $this->request->getJSON(true) ?? $this->request->getRawInput();

        if (!$validation->setRules($rules)->run($data)) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal memperbarui data UMKM',
                'errors'  => $validation->getErrors(),
            ], 400);
        }

        $updateData = [
            'nama_umkm' => $data['nama_umkm'] ?? $existing['nama_umkm'],
            'pemilik'   => $data['pemilik'] ?? $existing['pemilik'],
            'alamat'    => $data['alamat'] ?? $existing['alamat'],
            'kategori'  => $data['kategori'] ?? $existing['kategori'],
            'kontak'    => $data['kontak'] ?? $existing['kontak'],
        ];

        $result = $umkmModel->update($id, $updateData);

        if ($result === false) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal memperbarui data UMKM',
                'errors'  => $umkmModel->errors(),
            ], 500);
        }

        $updatedData = $umkmModel->find($id);

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diperbarui',
            'data'    => $updatedData,
        ], 200);
    }

    // 5. DELETE /umkm/{id} or /api/umkm/{id} (Delete)
    public function delete($id = null)
    {
        $umkmModel = new UmkmModel();
        $data = $umkmModel->find($id);

        if (!$data) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal menghapus data UMKM',
                'errors'  => [
                    'id' => 'Data UMKM tidak ditemukan',
                ],
            ], 404);
        }

        $umkmModel->delete($id);

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil dihapus',
            'data'    => [
                'id'        => $data['id'],
                'nama_umkm' => $data['nama_umkm'],
            ],
        ], 200);
    }
}
