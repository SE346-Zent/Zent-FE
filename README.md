# Zent-FE

Frontend của hệ thống Zent, được phát triển bằng Flutter.

## Cách 1: Tải bản phát hành (Khuyến nghị)

Nếu chỉ muốn sử dụng ứng dụng, hãy tải phiên bản mới nhất tại:

https://github.com/SE346-Zent/Zent-FE/releases

Chọn file phù hợp với hệ điều hành của bạn và chạy trực tiếp.

---

## Cách 2: Chạy từ mã nguồn

### Yêu cầu

Trước khi chạy dự án, cần cài đặt:

- Git
- Flutter SDK (Flutter đã bao gồm Dart SDK)

### 1. Cài đặt Git

Tải và cài đặt Git tại:

https://git-scm.com/downloads

Kiểm tra cài đặt:

```bash
git --version
```

### 2. Cài đặt Flutter SDK

Làm theo hướng dẫn chính thức của Flutter:

https://docs.flutter.dev/get-started/install

Sau khi cài đặt, kiểm tra môi trường:

```bash
flutter doctor
```

Hoặc:

```bash
flutter doctor -v
```

Đảm bảo các thành phần cần thiết đều được đánh dấu ✓ trước khi tiếp tục.

### 3. Clone dự án

```bash
git clone https://github.com/SE346-Zent/Zent-FE.git
cd Zent-FE
```

### 4. Cài đặt dependencies

```bash
flutter pub get
```

Lệnh này sẽ tải toàn bộ thư viện được khai báo trong `pubspec.yaml`.

### 5. Chạy ứng dụng

Liệt kê các thiết bị khả dụng:

```bash
flutter devices
```

Chạy ứng dụng:

```bash
flutter run
```

### Build ứng dụng

Android APK:

```bash
flutter build apk
```

Windows:

```bash
flutter build windows
```

Web:

```bash
flutter build web
```

---

## Xử lý một số lỗi thường gặp

### flutter: command not found

Nguyên nhân:
- Flutter chưa được cài đặt.
- Flutter chưa được thêm vào biến môi trường PATH.

Kiểm tra:

```bash
flutter doctor
```

### Lỗi thiếu dependencies

Chạy lại:

```bash
flutter clean
flutter pub get
```

### Kiểm tra môi trường Flutter

```bash
flutter doctor -v
```

Lệnh này hiển thị chi tiết các thành phần còn thiếu hoặc cấu hình chưa đúng.
