# Proyecto Flutter

Este proyecto es una aplicación Flutter que se puede ejecutar en múltiples plataformas, incluyendo iOS, Android, macOS, Linux y Windows.

# Integrantes del equipo de desarrollo

Darío Antonio Gutiérrez Álvarez - 221245
Luis Alejandro Martinez Montoya - 213021
Christian Darinel Escobar Guillen - 221192
Gálvez Miranda Ulises - 213691

## Clonar el Proyecto

Para clonar el proyecto, sigue estos pasos:

1. Abre una terminal.
2. Ejecuta el siguiente comando para clonar el repositorio:

    ```sh
    git clone https://github.com/tu-usuario/tu-repositorio.git
    ```

3. Navega al directorio del proyecto:

    ```sh
    cd tu-repositorio
    ```

## Correr el Proyecto

### Requisitos Previos

Asegúrate de tener instalado Flutter en tu máquina. Puedes seguir las instrucciones de instalación en la [documentación oficial de Flutter](https://flutter.dev/docs/get-started/install).

### iOS

1. Abre el proyecto en Xcode:

    ```sh
    open ios/Runner.xcworkspace
    ```

2. Selecciona un simulador o un dispositivo físico.
3. Haz clic en el botón de "Run" para compilar y ejecutar la aplicación.

### Android

1. Conecta un dispositivo Android o inicia un emulador.
2. Ejecuta el siguiente comando en la terminal:

    ```sh
    flutter run
    ```

### macOS

1. Abre el proyecto en Xcode:

    ```sh
    open macos/Runner.xcodeproj
    ```

2. Selecciona un simulador o un dispositivo físico.
3. Haz clic en el botón de "Run" para compilar y ejecutar la aplicación.

### Linux

1. Asegúrate de tener CMake instalado.
2. Ejecuta los siguientes comandos en la terminal:

    ```sh
    cd linux
    mkdir build
    cd build
    cmake ..
    make
    ./tu-aplicacion
    ```

### Windows

1. Abre el proyecto en Visual Studio.
2. Selecciona la configuración de "Debug" o "Release".
3. Haz clic en el botón de "Run" para compilar y ejecutar la aplicación.

## Funcionalidad

Esta aplicación Flutter permite:

- Ejecutar un proyecto Dart de manera headless utilizando [`FlutterHeadlessDartRunner`](build/ios/iphonesimulator/Runner.app/Frameworks/Flutter.framework/Headers/FlutterHeadlessDartRunner.h).
- Configurar y gestionar diferentes configuraciones de compilación en Xcode y CMake.
- Soporte para múltiples plataformas, incluyendo iOS, Android, macOS, Linux y Windows.

Para más detalles sobre la funcionalidad específica, revisa los archivos de cabecera en los directorios correspondientes y los archivos de configuración de CMake.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o un pull request para discutir cualquier cambio que te gustaría hacer.

