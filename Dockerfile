# Temel imaj: OpenJDK
FROM openjdk:17-slim

# Çalışma dizini oluştur
WORKDIR /app

# Java dosyasını kopyala
COPY App.java .

# Java dosyasını derle
RUN javac App.java

# Uygulamayı çalıştır
CMD ["java", "App"]
