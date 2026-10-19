NAMA : MUHAMMAD ANDY DWI SUBANDI
NIM : 264311076
KELAS : 1C


SOAL 1: Data Definition & Relasi

 1. TABEL INDUK: petugas
CREATE TABLE petugas (
    nrp            VARCHAR(20)  NOT NULL,
    nama_petugas   VARCHAR(100) NOT NULL,
    pangkat        VARCHAR(50),
    PRIMARY KEY (nrp)
) 

 2. TABEL INDUK: kendaraan 
CREATE TABLE kendaraan (
    nomor_polisi     VARCHAR(15)  NOT NULL,
    jenis_kendaraan  VARCHAR(10)  NOT NULL,
    merk             VARCHAR(50),
    nama_pemilik     VARCHAR(100),
    alamat_pemilik   VARCHAR(200),
    PRIMARY KEY (nomor_polisi),
    CONSTRAINT chk_jenis CHECK (jenis_kendaraan IN ('Roda 2', 'Roda 4'))
) 

 3. TABEL TRANSAKSI: pelanggaran 
CREATE TABLE pelanggaran (
    no_tilang     VARCHAR(30)  NOT NULL,
    no_referensi  VARCHAR(30),
    tanggal       DATE         NOT NULL,
    nrp_petugas   VARCHAR(20)  NOT NULL,
    nomor_polisi  VARCHAR(15)  NOT NULL,
    PRIMARY KEY (no_tilang),
    CONSTRAINT fk_pelanggaran_petugas
        FOREIGN KEY (nrp_petugas)  REFERENCES petugas(nrp)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pelanggaran_kendaraan
        FOREIGN KEY (nomor_polisi) REFERENCES kendaraan(nomor_polisi)
        ON DELETE RESTRICT ON UPDATE CASCADE
) 

SOAL 2: Operasi CRUD Dasar

1. [CREATE] INSERT 3 baris per tabel (total 9 baris)
-- Tabel induk 1: petugas
INSERT INTO petugas (nrp, nama_petugas, pangkat) VALUES
('81020145', 'Budi Santoso',  'Aipda'),
('83050231', 'Rina Wulandari', 'Bripka'),
('85070312', 'Agus Prasetyo', 'Briptu');

-- Tabel induk 2: kendaraan
INSERT INTO kendaraan (nomor_polisi, jenis_kendaraan, merk, nama_pemilik, alamat_pemilik) VALUES
('AE 1234 AB', 'Roda 2', 'Honda Beat',    'Slamet Riyadi',  'Jl. Serayu No. 12, Madiun'),
('AE 5678 CD', 'Roda 4', 'Toyota Avanza', 'Dewi Lestari',   'Jl. Salak No. 45, Madiun'),
('N 9012 EF',  'Roda 2', 'Yamaha NMAX',   'Hendra Gunawan', 'Jl. Dieng No. 10, Maiun');

-- Tabel transaksi: pelanggaran
INSERT INTO pelanggaran (no_tilang, no_referensi, tanggal, nrp_petugas, nomor_polisi) VALUES
('PLS-2026-001', 'REF-A001', '2026-10-01', '81020145', 'AE 1234 AB'),
('PLS-2026-002', 'REF-A002', '2026-10-03', '83050231', 'AE 5678 CD'),
('PLS-2026-003', 'REF-A003', '2026-10-05', '85070312', 'N 9012 EF');

2. [READ] Tampilkan seluruh isi salah satu tabel induk
SELECT * FROM kendaraan;

3. [UPDATE] Ubah satu nilai pada tabel transaksi
UPDATE pelanggaran
SET tanggal = '2026-10-02'
WHERE no_tilang = 'TLG-2026-001';
-- Cek hasil update
SELECT * FROM pelanggaran WHERE no_tilang = 'TLG-2026-001';

4. [DELETE] Hapus satu baris pada tabel transaksi
DELETE FROM pelanggaran
WHERE no_tilang = 'TLG-2026-003';
-- Cek hasil delete (tersisa 2 baris)
SELECT * FROM pelanggaran;

SOAL 3: Query Kompleks & Agregasi Laporan

QUERY MENGHITUNG JUMLAH PELANGGARAN YANG DITANGANI
SELECT p.nrp,
       p.nama_petugas,
       COUNT(pl.no_tilang) AS total_pelanggaran
FROM pelanggaran pl
JOIN petugas p ON pl.nrp_petugas = p.nrp
WHERE pl.tanggal BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY p.nrp, p.nama_petugas;
