<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class UmkmController extends ResourceController
{
    protected $modelName = 'App\Models\UmkmModel';
    protected $format    = 'json';

    /**
     * Safely extract request payload from JSON, POST form-data, or PUT raw input.
     */
    private function getRequestData(): array
    {
        $contentType = $this->request->getHeaderLine('Content-Type');

        if (str_contains($contentType, 'application/json')) {
            return $this->request->getJSON(true) ?? [];
        }

        if ($this->request->getMethod() === 'POST') {
            return $this->request->getPost() ?? [];
        }

        return $this->request->getRawInput() ?? [];
    }

    // 1. GET /umkm or /api/umkm (Read all)
    public function index()
    {
        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diambil',
            'data'    => $this->model->findAll(),
        ], 200);
    }

    // 2. GET /umkm/{id} or /api/umkm/{id} (Read single)
    public function show($id = null)
    {
        $umkm = $this->model->find($id);

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
        $data  = $this->getRequestData();
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

        if (!$this->validateData($data, $rules)) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal menambahkan data UMKM',
                'errors'  => $this->validator->getErrors(),
            ], 400);
        }

        $insertedId = $this->model->insert([
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
                'errors'  => $this->model->errors(),
            ], 500);
        }

        return $this->respondCreated([
            'success' => true,
            'message' => 'Data UMKM berhasil ditambahkan',
            'data'    => $this->model->find($insertedId),
        ]);
    }

    // 4. PUT /umkm/{id} or /api/umkm/{id} (Update)
    public function update($id = null)
    {
        $existing = $this->model->find($id);

        if (!$existing) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal memperbarui data UMKM',
                'errors'  => [
                    'id' => 'Data UMKM tidak ditemukan',
                ],
            ], 404);
        }

        $data  = $this->getRequestData();
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

        if (!$this->validateData($data, $rules)) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal memperbarui data UMKM',
                'errors'  => $this->validator->getErrors(),
            ], 400);
        }

        $updateData = [
            'nama_umkm' => $data['nama_umkm'] ?? $existing['nama_umkm'],
            'pemilik'   => $data['pemilik'] ?? $existing['pemilik'],
            'alamat'    => $data['alamat'] ?? $existing['alamat'],
            'kategori'  => $data['kategori'] ?? $existing['kategori'],
            'kontak'    => $data['kontak'] ?? $existing['kontak'],
        ];

        if ($this->model->update($id, $updateData) === false) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal memperbarui data UMKM',
                'errors'  => $this->model->errors(),
            ], 500);
        }

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diperbarui',
            'data'    => $this->model->find($id),
        ], 200);
    }

    // 5. DELETE /umkm/{id} or /api/umkm/{id} (Delete)
    public function delete($id = null)
    {
        $data = $this->model->find($id);

        if (!$data) {
            return $this->respond([
                'success' => false,
                'message' => 'Gagal menghapus data UMKM',
                'errors'  => [
                    'id' => 'Data UMKM tidak ditemukan',
                ],
            ], 404);
        }

        $this->model->delete($id);

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