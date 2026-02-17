## 1. 프로젝트 개요
- **목적**: 한국어, 영어, 텔루구어 간의 신속하고 자연스러운 소통을 위한 전용 번역기 앱
- **핵심 가치**: 부가 설명 없는 깔끔한 번역 결과, 현지 최적화된 문체(프리셋) 적용
- **타겟 플랫폼**: Android (Flutter)

## 2. 기술 스택
- **Framework**: Flutter
- **State Management**: GetX (단순하고 빠른 반응형 상태 관리)
- **Networking**: Dio (Gemini API 통신용)
- **LLM Engine**: Google Gemini 1.5 Flash API
- **Local Storage**: GetStorage (사용자 정의 프롬프트 및 설정값 저장)

## 3. 핵심 기능 요구사항

### 3.1. 번역 인터페이스 (Main Screen)
- **언어 선택 (Top)**:
    - 입력 언어: Radio 버튼 (한국어, 영어, 텔루구어 중 택 1)
    - 출력 언어: Checkbox 버튼 (한국어, 영어, 텔루구어 중 다중 선택 가능)
- **텍스트 입력창 (Input)**:
    - 멀티라인 입력 지원, 스크롤 가능
    - 힌트 텍스트: "번역할 내용을 입력하세요..."
- **번역 실행 버튼**:
    - 클릭 시 Dio를 통해 Gemini 1.5 Flash API 호출
    - 로딩 중에는 인디케이터 표시
- **번역 결과창 (Output)**:
    - 결과물 수정 가능(TextField 형태), 스크롤 가능
    - 여러 언어 선택 시 구분자(예: [English], [Telugu])와 함께 출력
- **액션 버튼 (Bottom)**:
    - **복사 버튼**: 결과창 텍스트를 클립보드에 즉시 복사
    - **프롬프트 수정 버튼**: 시스템 프롬프트를 수정할 수 있는 별도 페이지/모달로 이동

### 3.2. LLM 로직 (Gemini API 연동)
- **Model**: `gemini-1.5-flash`
- **System Instruction (핵심)**:
    - 역할: 인도 학생들과 소통하는 한국인 팀장/선생님
    - 스타일: "해섬 텔루구", "해섬 소통용" 스타일의 친근한 구어체
    - 제약 조건: 번역 결과 외에 "Here is the translation" 같은 서술형 문구 절대 금지
- **다중 출력 대응**: 여러 언어 선택 시 한 번의 API 호출로 모든 언어 결과를 받아오도록 프롬프트 설계

### 3.3. 설정 및 저장 (Persistence)
- 사용자가 수정한 '시스템 프롬프트'는 앱 재시작 시에도 유지 (GetStorage 활용)
- 최근 선택한 입력/출력 언어 설정값 저장

## 4. UI/UX 가이드라인 (첨부 이미지 준수)
- **레이아웃**: `SingleChildScrollView` 내부에 `Column` 배치
- **색상**: 깔끔한 라이트 블루 계열 (`Colors.blue.shade50`) 배경 활용
- **컴포넌트**:
    - 카드(Card) UI를 활용하여 입력/출력 영역 구분
    - 버튼은 하단에 고정하거나 리스트 하단에 배치

## 5. 단계별 구현 가이드 (Cursor용 지시서)
1. **Step 1**: `pubspec.yaml` 설정 (get, dio, get_storage, google_generative_ai 등)
2. **Step 2**: 기본 폴더 구조 생성 (MVC/Service 패턴: controller, view, service, model)
3. **Step 3**: GetX 기반의 UI 레이아웃 구현 (입력창, 체크박스, 버튼 등)
4. **Step 4**: Dio를 활용한 Gemini API Service 클래스 구현
5. **Step 5**: 시스템 프롬프트 관리 및 복사 기능 등 부가 기능 마무리