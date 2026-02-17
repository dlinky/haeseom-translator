# 해섬 번역기

한국어, 영어, 텔루구어 간의 신속하고 자연스러운 소통을 위한 전용 번역기 앱

## 기술 스택

- **Framework**: Flutter
- **State Management**: GetX
- **Networking**: Dio
- **LLM Engine**: Google Gemini 1.5 Flash API
- **Local Storage**: GetStorage

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── controllers/             # GetX 컨트롤러
│   └── translation_controller.dart
├── views/                   # UI 화면
│   ├── main_screen.dart
│   └── prompt_edit_screen.dart
├── services/                # 비즈니스 로직 서비스
│   ├── gemini_service.dart
│   └── storage_service.dart
├── models/                  # 데이터 모델
│   ├── language.dart
│   └── translation_result.dart
└── utils/                   # 유틸리티 (필요시 추가)
```

## 설정 방법

1. **의존성 설치**
   ```bash
   flutter pub get
   ```

2. **Gemini API 키 설정**
   
   `lib/services/gemini_service.dart` 파일에서 API 키를 설정하거나, 환경 변수로 설정:
   
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
   ```
   
   또는 `lib/services/gemini_service.dart`의 `apiKey` 변수를 직접 수정할 수 있습니다.

## 주요 기능

- 다국어 번역 (한국어, 영어, 텔루구어)
- 다중 출력 언어 지원
- 사용자 정의 시스템 프롬프트
- 번역 결과 복사 기능
- 설정 자동 저장

## 사용 방법

1. 입력 언어 선택 (라디오 버튼)
2. 출력 언어 선택 (체크박스, 다중 선택 가능)
3. 번역할 텍스트 입력
4. 번역하기 버튼 클릭
5. 결과 확인 및 복사

## 웹 배포 (Docker)

### 사전 요구사항
- Docker 및 Docker Compose 설치
- Ubuntu Server (또는 다른 Linux 배포판)

### 배포 방법

#### 방법 1: 배포 스크립트 사용 (권장)

1. **프로젝트 클론 및 이동**
   ```bash
   cd haeseom-translator
   ```

2. **배포 스크립트 실행 권한 부여**
   ```bash
   chmod +x deploy.sh
   ```

3. **배포 실행**
   ```bash
   ./deploy.sh
   ```

#### 방법 2: Docker Compose 직접 사용

1. **프로젝트 클론 및 이동**
   ```bash
   cd haeseom-translator
   ```

2. **Docker 이미지 빌드 및 실행**
   ```bash
   docker-compose up -d --build
   ```

3. **접속 확인**
   - 브라우저에서 `http://your-server-ip:7000` 접속

### Docker 명령어

- **컨테이너 시작**: `docker-compose up -d`
- **컨테이너 중지**: `docker-compose down`
- **로그 확인**: `docker-compose logs -f`
- **재빌드**: `docker-compose up -d --build`

### 포트 변경

포트를 변경하려면 `docker-compose.yml`과 `nginx.conf`의 포트 번호를 수정하세요.

### 주의사항

- 웹 버전은 브라우저의 LocalStorage를 사용하여 API 키와 설정을 저장합니다
- HTTPS 사용을 권장합니다 (프록시 서버 사용 또는 Let's Encrypt 설정)
