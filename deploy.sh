#!/bin/bash

# 해섬 번역기 웹 배포 스크립트

echo "🚀 해섬 번역기 웹 배포를 시작합니다..."

# Docker가 실행 중인지 확인
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker가 실행되지 않았습니다. Docker를 시작해주세요."
    exit 1
fi

# 기존 컨테이너 중지 및 제거
echo "📦 기존 컨테이너를 정리합니다..."
docker-compose down

# 이미지 빌드 및 컨테이너 시작
echo "🔨 Docker 이미지를 빌드합니다..."
docker-compose up -d --build

# 컨테이너 상태 확인
sleep 3
if docker ps | grep -q haeseom-translator-web; then
    echo "✅ 배포가 완료되었습니다!"
    echo "🌐 http://localhost:7000 에서 접속할 수 있습니다."
    echo ""
    echo "로그를 확인하려면: docker-compose logs -f"
else
    echo "❌ 배포 중 오류가 발생했습니다."
    echo "로그를 확인해주세요: docker-compose logs"
    exit 1
fi
