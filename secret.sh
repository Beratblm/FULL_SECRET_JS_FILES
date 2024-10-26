#!/bin/bash

# Kullanım: ./script.sh hedef_domain.com
domain=$1

# Dosya isimleri için domain adına göre değişkenler tanımlanıyor
subdomains_file="${domain}.txt"
live_subdomains_file="live${domain}.txt"
js_files_file="${domain}js.txt"
tokens_file="tokens_${domain}.txt"

# 1. Subdomainleri buluyor ve 'domain_adı.txt' dosyasına yazıyor
echo "[*] Subfinder ile subdomainleri topluyor..."
subfinder -d $domain | tee "$subdomains_file"

# 2. Ayakta olan subdomainleri filtreliyor ve 'live_domain_adı.txt' dosyasına yazıyor
echo "[*] Httpx ile canlı subdomainleri kontrol ediyor..."
httpx-toolkit -l "$subdomains_file" | tee "$live_subdomains_file"

# 3. JavaScript dosyalarını buluyor ve 'domain_adı_js.txt' dosyasına yazıyor
echo "[*] Katana ile JavaScript dosyalarını topluyor..."
katana -u "$live_subdomains_file" | grep ".js$" | tee "$js_files_file"

# 4. Mantra ile token araması yapıyor ve sadece tokenları kaydediyor
echo "[*] Mantra ile tokenleri çıkarıyor ve kaydediyor..."
cat "$js_files_file" | mantra | tee "$tokens_file"

# Geçici dosyaları silme (sadece js dosyasını koruyor)
echo "[*] Geçici dosyalar siliniyor (js dosyası hariç)..."
rm -f "$subdomains_file" "$live_subdomains_file"

echo "[*] İşlemler tamamlandı. Tokenlar '$tokens_file' dosyasına kaydedildi ve '$js_files_file' dosyası korundu."