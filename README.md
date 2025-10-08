# Documentación (README.md)

## Descripción breve de la API usada

Este proyecto consume la API pública de **Chuck Norris** disponible en https://api.chucknorris.io.

### Endpoint principal usado:
- **GET** `/jokes/search?query={texto}` - Busca chistes que contengan el texto especificado

### Ejemplo de respuesta JSON:
```json
{
  "total": 3,
  "result": [
    {
      "categories": [],
      "created_at": "2020-01-05 13:42:19.104863",
      "icon_url": "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
      "id": "abcd1234efgh5678",
      "updated_at": "2020-01-05 13:42:19.104863",
      "url": "https://api.chucknorris.io/jokes/abcd1234efgh5678",
      "value": "Chuck Norris can divide by zero."
    }
  ]
}
```

### Configuración:
- La URL base se configura mediante variables de entorno usando `flutter_dotenv`
- Archivo `.env` con `BASEURL=https://api.chucknorris.io`

## Arquitectura (carpetas)

La estructura del proyecto sigue el patrón de arquitectura limpia:

- **`models/`**: Clases y modelos de datos
  - `joke_model.dart` - Modelo para representar un chiste con todos sus campos
- **`services/`**: Servicios responsables de llamadas HTTP
  - `joke_service.dart` - Servicio que maneja las peticiones a la API de Chuck Norris
- **`views/`**: Pantallas y widgets organizados por funcionalidad
  - `http_API/` - Pantallas relacionadas con la funcionalidad de chistes
    - `api.dart` - Lista de chistes
    - `detalle.dart` - Detalle individual de un chiste
  - `home/`, `login/`, `about/`, etc. - Otras pantallas del proyecto
- **`routes/`**: Configuración de navegación
  - `app_router.dart` - Definición de rutas con GoRouter
- **`widgets/`**: Widgets reutilizables
  - `base_view.dart`, `custom_drawer.dart`

## Rutas definidas con `go_router` y parámetros

Las rutas están definidas en `lib/routes/app_router.dart` usando el paquete `go_router`:

| Ruta | Parámetros | Descripción |
|------|-----------|-------------|
| `/` | Ninguno | Pantalla principal (Home) |
| `/detalle/:id/:iconUrl/:value` | `id`, `iconUrl`, `value` | **Detalle del chiste** con parámetros codificados en URL |
| `/aboutme/:parametro/:metodo` | `parametro`, `metodo` | Pantalla 'About' con parámetros dinámicos |
| `/login` | Ninguno | Pantalla de autenticación |
| `/tabbar` | Ninguno | Pantalla con pestañas (TabBar) |
| `/usuarios` | Ninguno | Lista de usuarios (Future/async demo) |
| `/cronometro` | Ninguno | Cronómetro (Timer demo) |
| `/tarea_pesada` | Ninguno | Ejemplo de Isolate/tarea en background |
| `/jokes` | Ninguno | **Lista de chistes** (consulta a la API) |


### Funcionalidad de navegación:
- **Navegación desde lista**: Al hacer tap en un chiste de la lista (`/jokes`), se navega al detalle (`/detalle`) pasando los parámetros del chiste seleccionado
- **Parámetros codificados**: Los parámetros de URL se codifican/decodifican usando `Uri.encodeComponent()` y `Uri.decodeComponent()` para manejar caracteres especiales
- **Navegación con contexto**: Se utiliza `context.push()` para mantener el historial de navegación

---

# 📱 Proyecto Flutter - Navegación y Ciclo de Vida

## 🎯 Descripción del Proyecto

Este proyecto Flutter demuestra la implementación de navegación con `go_router`, paso de parámetros, uso de widgets especializados, manejo del ciclo de vida de los widgets y demás elementos vistos en la clase de programación móvil.

## Arquitectura y Navegación

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


### Diferencias entre Métodos de Navegación

| Método | Comportamiento | Botón Atrás | Ejecuta dispose() | Uso |
|--------|----------------|-------------|------------------|-----|
| `context.push()` | Apila nueva pantalla encima | ✅ SÍ | ❌ NO | AboutMe |
| `context.go()` | Reemplaza completamente la ruta | ❌ NO | ✅ SÍ | Login |
| `context.replace()` | Reemplaza en el stack actual | ✅ SÍ | ❌ NO | TabBar |


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



**¿Por qué es útil?** Permite que la app siga respondiendo mientras espera. Es como pedir comida en un restaurante: no te quedas parado esperando, puedes hacer otras cosas.

### ⏲️ Timer
**¿Cuándo usarlo?**
- Para hacer algo cada cierto tiempo (como un cronómetro)
- Para tareas repetitivas que necesitan ejecutarse periódicamente

**¿Por qué es útil?** Es perfecto para cosas que necesitan actualizarse constantemente, como relojes o contadores.

### 🏭 Isolate
**¿Cuándo usarlo?**
- Para tareas MUY pesadas que podrían "congelar" la pantalla
- Cuando necesitas calcular algo complejo sin afectar la interfaz

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

## 🤔 ¿Por qué usar cada uno?

| Herramienta | Lo uso cuando... | Ejemplo en la vida real |
|-------------|------------------|------------------------|
| **Future/async** | Necesito esperar algo sin congelar la app | Esperar que llegue un mensaje de WhatsApp |
| **Timer** | Quiero que algo pase cada X tiempo | La alarma del celular cada mañana |
| **Isolate** | Tengo que hacer algo súper pesado | Pedirle a un amigo que haga la tarea difícil mientras yo hago otra cosa |

## 🚀 Instalación y Uso

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