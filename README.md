# 📱 Proyecto Flutter - Navegación y Ciclo de Vida

## 🎯 Descripción del Proyecto

Este proyecto Flutter demuestra la implementación de navegación con `go_router`, paso de parámetros, uso de widgets especializados y manejo del ciclo de vida de los widgets.

## 🏗️ Arquitectura y Navegación

### Rutas Disponibles

| Ruta | Descripción | Parámetros | Tecnología |
|------|-------------|------------|------------|
| `/` | Pantalla principal (Home) | Ninguno | Navegación hub |
| `/aboutme/:parametro/:metodo` | Pantalla "Acerca de" | `parametro`: título<br>`metodo`: navegación | GridView |
| `/login` | Pantalla de autenticación | Ninguno | FlutterLogin |
| `/tabbar` | Pantalla con pestañas | Ninguno | TabBar |
| `/usuarios` | Lista de usuarios | Ninguno | Future/async |
| `/cronometro` | Cronómetro funcional | Ninguno | Timer |
| `/tarea_pesada` | Tareas en segundo plano | Ninguno | Isolate |

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

## ⏱️ Programación Asíncrona - ¿Cuándo usar qué?

### 🔄 Future y async/await
**¿Cuándo usarlo?**
- Cuando necesitas hacer una tarea que toma tiempo (como cargar datos de internet)
- Para operaciones que no bloqueen la pantalla mientras esperan

**En mi proyecto:**
```dart
Future<List<Map<String, dynamic>>> getUsuarios() async {
  await Future.delayed(const Duration(seconds: 2)); // Simula carga de datos
  return usuarios; // Devuelve la lista cuando está lista
}
```

**¿Por qué es útil?** Permite que la app siga respondiendo mientras espera. Es como pedir comida en un restaurante: no te quedas parado esperando, puedes hacer otras cosas.

### ⏲️ Timer
**¿Cuándo usarlo?**
- Para hacer algo cada cierto tiempo (como un cronómetro)
- Para tareas repetitivas que necesitan ejecutarse periódicamente

**En mi proyecto:**
```dart
Timer.periodic(const Duration(seconds: 1), (timer) {
  // Se ejecuta cada segundo para actualizar el cronómetro
  setState(() {
    segundos++;
  });
});
```

**¿Por qué es útil?** Es perfecto para cosas que necesitan actualizarse constantemente, como relojes o contadores.

### 🏭 Isolate
**¿Cuándo usarlo?**
- Para tareas MUY pesadas que podrían "congelar" la pantalla
- Cuando necesitas calcular algo complejo sin afectar la interfaz

**En mi proyecto:**
```dart
// Suma de millones de números sin congelar la app
static void _calculoSumaPesada(SendPort sendPort) async {
  int suma = 0;
  for (int i = 1; i <= 500000000; i++) {
    suma += i; // Esto tomaría mucho tiempo en el hilo principal
  }
}
```

**¿Por qué es útil?** Es como tener un ayudante que hace el trabajo pesado mientras tú sigues atendiendo a los clientes.

## 📱 Pantallas y Flujos del Proyecto

### Estructura de Pantallas
```
📱 App Principal
├── 🏠 Home (Pantalla principal)
│   ├── → AboutMe (con parámetros)
│   ├── → Login 
│   ├── → TabBar
│   ├── → Usuarios (Future/async)
│   ├── → Cronómetro (Timer)
│   └── → Tarea Pesada (Isolate)
│
├── 👤 AboutMe
│   └── GridView con opciones de navegación
│
├── 🔐 Login  
│   └── FlutterLogin widget
│
├── 📋 TabBar
│   ├── Car Tab
│   ├── Transit Tab  
│   └── Bike Tab
│
├── 👥 Usuarios
│   └── Lista con carga asíncrona (Future)
│
├── ⏱️ Cronómetro  
│   └── Timer cada 1 segundo
│
└── 🏭 Tarea Pesada
    ├── Tarea básica (ejemplo del profe)
    └── Suma pesada (500M números)
```

### Flujo de Cronómetro
```
Usuario presiona "Iniciar"
         ↓
Timer.periodic inicia (1 segundo)
         ↓
Cada segundo: setState() actualiza pantalla
         ↓
Usuario ve números cambiando en tiempo real
         ↓
Usuario presiona "Parar" → Timer se cancela
```

### Flujo de Tarea Pesada
```
Usuario presiona "Ejecutar suma pesada"
         ↓
Se crea un Isolate (hilo separado)
         ↓
Isolate calcula suma de 500M números
         ↓
App sigue funcionando normal (no se congela)
         ↓
Isolate termina y envía resultado
         ↓
Pantalla se actualiza con el resultado
```

### Flujo de Usuarios (Async)
```
Usuario entra a pantalla Usuarios
         ↓
Pantalla muestra "Cargando..."
         ↓
Future.delayed simula carga de 2 segundos
         ↓
getUsuarios() devuelve lista completa
         ↓
setState() actualiza y muestra usuarios
```

## 🤔 ¿Por qué usar cada uno?

| Herramienta | Lo uso cuando... | Ejemplo en la vida real |
|-------------|------------------|------------------------|
| **Future/async** | Necesito esperar algo sin congelar la app | Esperar que llegue un mensaje de WhatsApp |
| **Timer** | Quiero que algo pase cada X tiempo | La alarma del celular cada mañana |
| **Isolate** | Tengo que hacer algo súper pesado | Pedirle a un amigo que haga la tarea difícil mientras yo hago otra cosa |

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

### Navegación y Widgets
- ✅ Navegación con GoRouter y paso de parámetros
- ✅ Diferenciación entre push, go y replace
- ✅ GridView, TabBar y FlutterLogin
- ✅ Ciclo de vida completo con prints informativos
- ✅ Manejo de recursos con dispose()

### Programación Asíncrona
- ✅ **Future/async/await** - Carga de usuarios con simulación de delay
- ✅ **Timer.periodic** - Cronómetro que cuenta cada segundo
- ✅ **Isolate** - Tareas pesadas sin congelar la interfaz
  - Tarea básica (ejemplo del profesor)
  - Suma pesada (500 millones de números)
- ✅ **setState()** - Actualización reactiva de la UI

## 👨‍💻 Datos del Estudiante

**Nombre:** Juan Sebastian Cadena Varela  
**Código:** 230221022

---

*Proyecto desarrollado para la clase de Desarrollo Móvil 2025-2*