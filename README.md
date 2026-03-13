# Tutorial 3 Game Development 2025/2026 Genap

## Eksplorasi Mekanika Pergerakan Karakter

Pada proyek ini saya melakukan eksplorasi berbagai mekanika pergerakan karakter 2D menggunakan Godot 4 dengan `CharacterBody2D`.

Mekanika yang saya implementasikan ada:
- **Double Jump**
- **Dashing** (Double Tap)
- **Crouching**
- **Hang** (Rope)
- **Climb** (Ladder)
- **Sprite Polishing & Directional Animation**

Implementasi dilakukan dengan memanfaatkan sistem _velocity_, pengecekan `is_on_floor()`, serta pendekatan berbasis state _boolean_ seperti `is_dashing`, `is_on_ladder`, dan `is_on_rope` untuk mengatur prioritas perilaku karakter. 

1.  Mekanika _double jump_ menggunakan sistem pembatasan jumlah lompatan, sedangkan _dash_ memanfaatkan deteksi selisih waktu antar input untuk membaca _double tap_ arah.
2.  Pada sistem _climb_ dan _hang_, _gravity_ dihentikan sementara dan pergerakan dikontrol secara manual agar tidak terjadi konflik dengan _movement_ normal.
3.  Untuk animasi, saya menerapkan sistem prioritas kondisi agar transisi seperti _idle_, _walk_, _run_, _jump_, _fall_, _slide_, _crouch_, dan _climb_ dapat berjalan dengan konsisten sesuai state karakter.

Proses implementasi ini juga mengacu pada beberapa referensi tutorial seperti 

**Dokumentasi Resmi:**
- Godot CharacterBody2D: https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
- How to make a wall climb: https://forum.godotengine.org/t/how-to-make-a-wall-climb/102144

**Video Referensi:**
- How To Climb : https://youtu.be/8F0jrZE-nEI?si=rypr9o31Yv6wOlXI
- How To Make Dash: https://youtu.be/NL5e1mfwl5M?si=sui7HKDgVXtb53pG
- How To Double Jump: https://youtu.be/DW4CQoYddXQ?si=_Z1ABmM9m2aTnf0e
- Godot Sprite Animation : https://youtu.be/-f1bHR0iiEY?si=4M2GTmVGdc0uHaSU

Secara keseluruhan, eksplorasi ini membantu saya memahami manajemen _state_ sederhana, manipulasi _physics_ berbasis _velocity_, serta pentingnya sinkronisasi antara logika pergerakan dan animasi dalam pengembangan game 2D.

--- 

## Tutorial 5: Assets Creation & Integration

Pada Tutorial 5 ini, saya mengimplementasikan berbagai fitur audio dan objek baru ke dalam permainan yang sudah dibuat di Tutorial 3.

### Objek Baru

Saya menambahkan dua objek baru ke dalam permainan menggunakan spritesheet dari **craftpix**, yaitu **Deer** dan **Fox**. Kedua objek ini memiliki animasi berjalan menggunakan _spritesheet_, serta perilaku yang berbalik arah ketika mencapai ujung _platform_.

### Background Music

Saya menambahkan musik latar bertema salju yang diputar otomatis saat permainan dimulai menggunakan node `AudioStreamPlayer2D`.

### Audio Feedback Interaksi

Saya juga mengimplementasikan interaksi antara player dengan objek baru:
- Ketika player **memukul Deer**, deer akan mengeluarkan suara lalu menghilang dari scene menggunakan `queue_free()`
- Ketika player **memukul Fox**, fox akan mengeluarkan animasi dan suara kesakitan namun tidak menghilang

Deteksi pukulan menggunakan perhitungan jarak antara posisi global player dan musuh, sehingga tidak bergantung pada _collision shape_.

### Audio Animasi Player

Setiap gerakan player dilengkapi dengan efek suara:
- **Jump & Double Jump** - suara jump diputar dua kali saat double jump
- **Dash** - suara _whoosh_ saat melakukan dash
- **Crouch** - suara saat pertama kali jongkok
- **Walk/Run** - suara langkah yang loop selama bergerak
- **Climb** - suara saat memanjat ladder
- **Hang** - suara rantai saat bergantung di chain
- **Punch** - suara pukulan saat menyerang

### Sistem Audio Posisional

Saya mengimplementasikan sistem audio yang relatif terhadap posisi objek menggunakan `AudioStreamPlayer2D` pada objek Wave dan `AudioListener2D` pada player. Semakin jauh player dari posisi wave, semakin kecil suara air yang terdengar.

### Referensi

| Aset | Sumber |
|------|--------|
| Chain | https://pixabay.com/sound-effects/film-special-effects-chain-rattling-46399/ |
| Crouch | https://youtu.be/koBWiaRzHUo?si=9e6UqNgSnUKhUkv3 |
| Climb | https://pixabay.com/sound-effects/film-special-effects-ladder-82581/ |
| Punch | https://pixabay.com/sound-effects/film-special-effects-classic-punch-impact-352711/ |
| Dash | https://pixabay.com/sound-effects/film-special-effects-simple-whoosh-382724/ |
| Deer SFX | https://youtu.be/huhmv5F7ljI?si=2dre415TxgHYeLrT |
| Fox SFX | https://youtu.be/Ak0Z5GVlPpY?si=455zvZa-F4VF6TRJ |
| Jump | https://youtu.be/Y8bSsRVr3Yg?si=uJLyvM7LjG7VvIjU |
| Walk | https://youtu.be/uzOuZVy1nmg?si=x42rE3UggUOWGlzZ |
| Snow Music | https://opengameart.org/content/take-a-trip-in-winter-wonderland-generalskar-migfus20-trevor-lentz |
| Wave | https://pixabay.com/sound-effects/nature-ocean-waves-376898/ |