# 📱 Proyecto Flutter - Navegación y Ciclo de Vida

## 🎯 Descripción del Proyecto

Este proyecto Flutter demuestra la implementación de navegación con `go_router`, paso de parámetros, uso de widgets especializados y manejo del ciclo de vida de los widgets.

## 🏗️ Arquitectura y Navegación

### Rutas Disponibles

| Ruta | Descripción | Parámetros |
|------|-------------|------------|
| `/` | Pantalla principal (Home) | Ninguno |
| `/aboutme/:parametro/:metodo` | Pantalla "Acerca de" | `parametro`: título a mostrar<br>`metodo`: método de navegación usado |
| `/login` | Pantalla de autenticación | Ninguno |
| `/tabbar` | Pantalla con pestañas | Ninguno |

### Paso de Parámetros

- **Desde Home hacia AboutMe:** Se envía el título actual y el método de navegación utilizado
- **Captura en AboutMe:** Los parámetros se muestran en el AppBar como `parametro - metodo`

### Diferencias entre Métodos de Navegación

| Método | Comportamiento | Botón Atrás | Ejecuta dispose() | Uso |
|--------|----------------|-------------|------------------|-----|
| `context.push()` | Apila nueva pantalla encima | ✅ SÍ | ❌ NO | AboutMe |
| `context.go()` | Reemplaza completamente la ruta | ❌ NO | ✅ SÍ | Login |
| `context.replace()` | Reemplaza en el stack actual | ✅ SÍ | ❌ NO | TabBar |

## 🧩 Widgets Implementados

### 1. GridView (AboutMe)
**Razón de elección:** Perfecto para mostrar menús de opciones en formato de cuadrícula, permitiendo una navegación visual e intuitiva.

### 2. TabBar (Bar)
**Razón de elección:** Ideal para organizar contenido relacionado en secciones separadas (Car, Transit, Bike), mejorando la experiencia de usuario.

### 3. FlutterLogin (Login)
**Razón de elección:** Widget especializado que proporciona una interfaz de autenticación profesional completa con formularios, validación, animaciones y recuperación de contraseña.

## 🔄 Ciclo de Vida de Widgets

| Método | Cuándo se ejecuta | Propósito |
|--------|------------------|-----------|
| `initState()` | Al crear el widget por primera vez | Inicializar variables, controllers, listeners |
| `didChangeDependencies()` | Cuando cambian las dependencias | Responder a cambios de tema, configuración |
| `build()` | Cada vez que se necesita reconstruir | Construir la interfaz de usuario |
| `setState()` | Cuando se cambia el estado interno | Actualizar la UI cuando cambian los datos |
| `dispose()` | Al destruir el widget completamente | Liberar recursos (controllers, streams, timers) |

**Nota:** `dispose()` solo se ejecuta al navegar con `context.go()` porque destruye completamente el widget.

## 🚀 Instalación y Uso

### Dependencias Principales
```yaml
dependencies:
  go_router: ^13.2.4
  flutter_login: ^4.2.1
```

### Instalación
```bash
flutter pub get
flutter run
```

### Credenciales de Prueba (Login)
- **Email:** `dribbble@gmail.com` | **Password:** `12345`
- **Email:** `hunter@gmail.com` | **Password:** `hunter`

## 📊 Características Implementadas

- ✅ Navegación con GoRouter y paso de parámetros
- ✅ Diferenciación entre push, go y replace
- ✅ GridView, TabBar y FlutterLogin
- ✅ Ciclo de vida completo con prints informativos
- ✅ Manejo de recursos con dispose()

## 👨‍💻 Datos del Estudiante

**Nombre:** Juan Sebastian Cadena Varela  
**Código:** 230221022

---

*Proyecto desarrollado para la clase de Desarrollo Móvil 2025-2*