CREATE TABLE petugas (
    nrp_petugas VARCHAR(20) PRIMARY KEY,
    nama_petugas VARCHAR(100) NOT NULL
);

CREATE TABLE kamera (
    id_kamera VARCHAR(20) PRIMARY KEY,
    lokasi_kamera VARCHAR(255) NOT NULL,
    batas_kecepatan INT NOT NULL
);

CREATE TABLE aturan_pasal (
    kode_pelanggaran VARCHAR(20) PRIMARY KEY,
    kategori_pelanggaran VARCHAR(100) NOT NULL,
    pasal_pelanggaran VARCHAR(255) NOT NULL
);

CREATE TABLE kendaraan (
    nomor_polisi VARCHAR(20) PRIMARY KEY,
    jenis_kendaraan ENUM('Motor', 'Mobil', 'Barang') NOT NULL,
    merk_kendaraan VARCHAR(50) NOT NULL,
    warna VARCHAR(30) NOT NULL,
    nama_pemilik VARCHAR(100) NOT NULL,
    alamat_pemilik TEXT NOT NULL,
    masa_berlaku_stnk DATE NOT NULL,
    no_rangka VARCHAR(50) NOT NULL UNIQUE,
    no_mesin VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE sepeda_motor (
    nomor_polisi VARCHAR(20) PRIMARY KEY,
    kapasitas_mesin_cc INT NOT NULL,
    jenis_motor VARCHAR(50) NOT NULL,
    CONSTRAINT fk_motor 
        FOREIGN KEY (nomor_polisi) 
        REFERENCES kendaraan(nomor_polisi) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE mobil_penumpang (
    nomor_polisi VARCHAR(20) PRIMARY KEY,
    jumlah_kursi INT NOT NULL,
    jenis_bodi VARCHAR(50) NOT NULL,
    CONSTRAINT fk_mobil 
        FOREIGN KEY (nomor_polisi) 
        REFERENCES kendaraan(nomor_polisi) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE kendaraan_barang (
    nomor_polisi VARCHAR(20) PRIMARY KEY,
    jbb_kg INT NOT NULL,
    jumlah_sumbu INT NOT NULL,
    dimensi_muatan VARCHAR(100) NOT NULL,
    CONSTRAINT fk_barang 
        FOREIGN KEY (nomor_polisi) 
        REFERENCES kendaraan(nomor_polisi) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE surat_tilang (
    no_surat_konfirmasi VARCHAR(50) PRIMARY KEY,
    tgl_surat DATE NOT NULL,
    wilayah_hukum VARCHAR(100) NOT NULL,
    nrp_petugas VARCHAR(20) NOT NULL,
    CONSTRAINT fk_surat_petugas 
        FOREIGN KEY (nrp_petugas) 
        REFERENCES petugas(nrp_petugas) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

CREATE TABLE detail_pelanggaran (
    no_surat_konfirmasi VARCHAR(50),
    no_referensi_sistem VARCHAR(50),
    nomor_polisi VARCHAR(20) NOT NULL,
    id_kamera VARCHAR(20) NOT NULL,
    kode_pelanggaran VARCHAR(20) NOT NULL,
    waktu_capture DATETIME NOT NULL,
    kecepatan INT NULL,
    PRIMARY KEY (no_surat_konfirmasi, no_referensi_sistem),
    CONSTRAINT fk_detail_surat 
        FOREIGN KEY (no_surat_konfirmasi) 
        REFERENCES surat_tilang(no_surat_konfirmasi) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_detail_kendaraan 
        FOREIGN KEY (nomor_polisi) 
        REFERENCES kendaraan(nomor_polisi) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT fk_detail_kamera 
        FOREIGN KEY (id_kamera) 
        REFERENCES kamera(id_kamera) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT fk_detail_pasal 
        FOREIGN KEY (kode_pelanggaran) 
        REFERENCES aturan_pasal(kode_pelanggaran) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

CREATE TABLE rekap_pelanggaran_harian (
    tanggal DATE NOT NULL,
    kode_pelanggaran VARCHAR(20) NOT NULL,
    jumlah_pelanggaran INT NOT NULL DEFAULT 0,
    total_denda DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (tanggal, kode_pelanggaran)
);

CREATE INDEX idx_waktu_capture ON detail_pelanggaran(waktu_capture);
CREATE INDEX idx_plat_nomor ON kendaraan(nomor_polisi);

CREATE TABLE sanggahan (
    id_sanggahan INT AUTO_INCREMENT PRIMARY KEY,
    no_surat_konfirmasi VARCHAR(50) NOT NULL UNIQUE, 
    nrp_petugas_verif VARCHAR(20) NULL, 
    tgl_sanggah DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    kategori_alasan ENUM('Kendaraan Dijual', 'Kendaraan Hilang', 'Bukan Pengemudi', 'Lainnya') NOT NULL,
    keterangan_detail TEXT NOT NULL,
    bukti_dokumen VARCHAR(255) NOT NULL,
    status_sanggahan ENUM('Menunggu', 'Proses Verifikasi', 'Diterima', 'Ditolak') DEFAULT 'Menunggu',
    CONSTRAINT fk_sanggahan_surat
        FOREIGN KEY (no_surat_konfirmasi)
        REFERENCES surat_tilang(no_surat_konfirmasi)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_sanggahan_petugas
        FOREIGN KEY (nrp_petugas_verif)
        REFERENCES petugas(nrp_petugas)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);
