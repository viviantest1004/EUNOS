#!/bin/sh
# EunOS ISO 빌드 스크립트
set -e

PROJ_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OVERLAY_DIR="$PROJ_DIR/eunos_overlay"
ISO_WORK="$PROJ_DIR/build/iso_work"
OUTPUT_ISO="$PROJ_DIR/EunOS-1.0.0-x86_64.iso"
APKOVL="$ISO_WORK/eunos.apkovl.tar.gz"

echo "=== EunOS 빌드 시작 ==="
echo ""

# ── 1. overlay 파일 실행 권한 설정 ──────────────────────────────
echo "[1/4] overlay 실행 권한 설정..."
chmod +x "$OVERLAY_DIR/usr/local/bin/"* 2>/dev/null || true
echo "  완료"

# ── 2. apkovl.tar.gz 재생성 ─────────────────────────────────────
echo "[2/4] eunos.apkovl.tar.gz 재생성..."
(
    cd "$OVERLAY_DIR"
    tar -czf "$APKOVL" \
        --owner=0 --group=0 \
        etc/ usr/ root/ 2>/dev/null || \
    tar -czf "$APKOVL" \
        etc/ usr/ root/
)
echo "  완료: $APKOVL ($(du -h "$APKOVL" | cut -f1))"

# ── 3. ISO 빌드 ─────────────────────────────────────────────────
echo "[3/4] ISO 빌드 중..."

# 기존 ISO 백업
if [ -f "$OUTPUT_ISO" ]; then
    cp "$OUTPUT_ISO" "${OUTPUT_ISO%.iso}-backup.iso" 2>/dev/null || true
fi

xorriso -as mkisofs \
    -o "$OUTPUT_ISO" \
    -isohybrid-mbr "$ISO_WORK/boot/syslinux/isohdpfx.bin" \
    -c boot/syslinux/boot.cat \
    -b boot/syslinux/isolinux.bin \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -eltorito-alt-boot \
    -e boot/grub/efi.img \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -V "EUNOS" \
    "$ISO_WORK"

echo "  완료: $OUTPUT_ISO ($(du -h "$OUTPUT_ISO" | cut -f1))"

# ── 4. 검증 ─────────────────────────────────────────────────────
echo "[4/4] ISO 검증..."
if file "$OUTPUT_ISO" | grep -q "ISO 9660"; then
    echo "  [✓] ISO 파일 정상 확인"
else
    echo "  [!] 경고: ISO 파일 형식 확인 필요"
fi

echo ""
echo "=== EunOS 빌드 완료 ==="
echo ""
echo "  ISO 경로: $OUTPUT_ISO"
echo ""
echo "  실행 방법:"
echo "    ./scripts/run_qemu.sh"
echo ""
echo "  복구 모드 실행:"
echo "    qemu-system-x86_64 -m 1G -smp 2 -cdrom '$OUTPUT_ISO' \\"
echo "      -boot d -nographic -serial mon:stdio"
echo "    → 부팅 메뉴에서 'EunOS 복구 환경' 선택"
