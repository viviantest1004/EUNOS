#!/bin/sh
# EunOS QEMU 실행 스크립트

ISO="/Users/cho-eun-yul/projects/EunOS/EunOS-1.0.0-x86_64.iso"

if [ ! -f "$ISO" ]; then
    echo "오류: ISO 파일을 찾을 수 없습니다: $ISO"
    exit 1
fi

echo "EunOS 1.0.0 QEMU 부팅 중..."
echo "종료: Ctrl+A, X"
echo ""

qemu-system-x86_64 \
    -m 1G \
    -smp 2 \
    -cdrom "$ISO" \
    -boot d \
    -nographic \
    -serial mon:stdio
