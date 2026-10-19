SOAL 1: Data Definition & Relasi

' 1. TABEL INDUK: petugas
CREATE TABLE petugas (
    nrp            VARCHAR(20)  NOT NULL,
    nama_petugas   VARCHAR(100) NOT NULL,
    pangkat        VARCHAR(50),
    PRIMARY KEY (nrp)
) ENGINE=InnoDB;

 2. TABEL INDUK: kendaraan 
CREATE TABLE kendaraan (
    nomor_polisi     VARCHAR(15)  NOT NULL,
    jenis_kendaraan  VARCHAR(10)  NOT NULL,
    merk             VARCHAR(50),
    nama_pemilik     VARCHAR(100),
    alamat_pemilik   VARCHAR(200),
    PRIMARY KEY (nomor_polisi),
    CONSTRAINT chk_jenis CHECK (jenis_kendaraan IN ('Roda 2', 'Roda 4'))
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;'
