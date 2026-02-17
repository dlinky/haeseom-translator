# Flutter 웹 빌드를 위한 Dockerfile
FROM ubuntu:22.04

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_VERSION=3.24.0

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Flutter 설치
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Flutter 설정
RUN flutter doctor
RUN flutter config --enable-web

# 작업 디렉토리 설정
WORKDIR /app

# pubspec 파일 복사 및 의존성 설치
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# 소스 코드 복사
COPY . .

# Flutter 웹 빌드
RUN flutter build web --release

# nginx 설정
RUN rm -rf /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# 빌드된 웹 파일을 nginx 디렉토리로 복사
RUN cp -r build/web/* /var/www/html/

# 포트 노출
EXPOSE 7000

# nginx 실행
CMD ["nginx", "-g", "daemon off;"]
