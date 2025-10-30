# Dockerfile pour La Bonne Alternance (mode Web)

FROM cirrusci/flutter:stable

WORKDIR /app

# Copier les fichiers du projet
COPY pubspec.yaml pubspec.lock ./
COPY lib ./lib
COPY assets ./assets
COPY analysis_options.yaml build.yaml ./
COPY env.example.json ./env.json

# Installer les dépendances
RUN flutter pub get

# Générer le code
RUN flutter pub run build_runner build --delete-conflicting-outputs

# Activer le web
RUN flutter config --enable-web

# Build web
RUN flutter build web --release

# Exposer le port
EXPOSE 8080

# Servir l'app web
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0", "--release"]
