#!/usr/bin/env bash
set -euo pipefail

# Proje kökü (app_build.sh ile aynı klasörde durduğu varsayımıyla)
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
APP_ANDROID_DIR="$PROJECT_ROOT/android"

# =========================
# 1) PROJE İÇİNDE KONTROL
# =========================

# Projenin kendi android klasöründe TRUE arıyoruz
PROJECT_MATCHES=$(grep -R -n --ignore-case \
    -e 'usesCleartextTraffic="true"' \
    -e 'cleartextTrafficPermitted="true"' \
    "$APP_ANDROID_DIR" 2>/dev/null || true)

if [ -n "$PROJECT_MATCHES" ]; then
  echo "[ERROR] CleartextTraffic PROJE içinde TRUE olarak set edilmiş:"
  echo ""
  echo "$PROJECT_MATCHES"
  echo ""
  echo "[ERROR] android/ altında android:usesCleartextTraffic=\"true\" veya"
  echo "[ERROR] cleartextTrafficPermitted=\"true\" KULLANILAMAZ."
  echo "[ERROR] Bu değerleri false yapın veya tamamen kaldırın."
  exit 1
fi

# =========================
# 2) pub.dev CACHE İÇİNDE KONTROL (hosted)
# =========================

ROOT="$HOME/.pub-cache/hosted/pub.dev"

if [ ! -d "$ROOT" ]; then
  echo "[CLEAR] pub.dev cache klasörü yok: $ROOT"
else
  echo "[CLEAR] Searching for cleartext entries in $ROOT ..."

  # usesCleartextTraffic="true" VEYA cleartextTrafficPermitted="true" içeren tüm dosyaları bul
  FILES=$(grep -R -l --ignore-case \
      -e 'usesCleartextTraffic="true"' \
      -e 'cleartextTrafficPermitted="true"' \
      "$ROOT" 2>/dev/null || true)

  if [ -n "$FILES" ]; then
    DELETED_EXAMPLES=""
    non_example_found=0

    # Her satır bir dosya yolu olacak şekilde dön
    while IFS= read -r f; do
      # Sadece example altında olanları otomatik sil
      if [[ "$f" == *"/example/"* ]]; then
        # path'ten example klasörünü çek
        ex_dir="${f%%/example/*}/example"

        # Bu example dizinini daha önce sildik mi?
        case " $DELETED_EXAMPLES " in
          *" $ex_dir "*) 
            # zaten silinmiş, geç
            continue
            ;;
        esac

        if [ -d "$ex_dir" ]; then
          echo "[CLEAR] Deleting example dir (hosted): $ex_dir"
          rm -rf "$ex_dir"
          DELETED_EXAMPLES="$DELETED_EXAMPLES $ex_dir"
        fi
      else
        # example DIŞINDA cleartext varsa -> HATA
        echo "[ERROR] Non-example cleartext file detected in pub.dev cache: $f"
        non_example_found=1
      fi
    done <<< "$FILES"

    if [ "$non_example_found" -ne 0 ]; then
      echo ""
      echo "[ERROR] CleartextTraffic (usesCleartextTraffic=\"true\" / cleartextTrafficPermitted=\"true\")"
      echo "[ERROR] example klasörleri DIŞINDA TRUE olarak ayarlanmış paket(ler) var (hosted)."
      echo "[ERROR] İlgili paketleri fork/path ile düzenleyip bu değerleri kaldırmadan build DEVAM ETMEYECEK."
      exit 1
    fi
  else
    echo "[CLEAR] pub.dev hosted cache içinde cleartext içeren dosya bulunamadı."
  fi
fi

# =========================
# 3) GIT CACHE İÇİNDE KONTROL (~/.pub-cache/git)
# =========================

GIT_ROOT="$HOME/.pub-cache/git"

if [ ! -d "$GIT_ROOT" ]; then
  echo "[CLEAR] git cache klasörü yok: $GIT_ROOT"
else
  echo "[CLEAR] Searching for cleartext entries in $GIT_ROOT ..."

  FILES_GIT=$(grep -R -l --ignore-case \
      -e 'usesCleartextTraffic="true"' \
      -e 'cleartextTrafficPermitted="true"' \
      "$GIT_ROOT" 2>/dev/null || true)

  if [ -n "$FILES_GIT" ]; then
    DELETED_EXAMPLES_GIT=""
    non_example_found_git=0

    while IFS= read -r f; do
      if [[ "$f" == *"/example/"* ]]; then
        ex_dir="${f%%/example/*}/example"

        case " $DELETED_EXAMPLES_GIT " in
          *" $ex_dir "*) 
            continue
            ;;
        esac

        if [ -d "$ex_dir" ]; then
          echo "[CLEAR] Deleting example dir (git): $ex_dir"
          rm -rf "$ex_dir"
          DELETED_EXAMPLES_GIT="$DELETED_EXAMPLES_GIT $ex_dir"
        fi
      else
        echo "[ERROR] Non-example cleartext file detected in git cache: $f"
        non_example_found_git=1
      fi
    done <<< "$FILES_GIT"

    if [ "$non_example_found_git" -ne 0 ]; then
      echo ""
      echo "[ERROR] CleartextTraffic (usesCleartextTraffic=\"true\" / cleartextTrafficPermitted=\"true\")"
      echo "[ERROR] example klasörleri DIŞINDA TRUE olarak ayarlanmış paket(ler) var (git cache)."
      echo "[ERROR] İlgili paketleri fork/path ile düzenleyip bu değerleri kaldırmadan build DEVAM ETMEYECEK."
      exit 1
    fi
  else
    echo "[CLEAR] git cache içinde cleartext içeren dosya bulunamadı."
  fi
fi

echo "[CLEAR] Done."
