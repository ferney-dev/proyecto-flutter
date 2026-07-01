# app_bienestarmisena_v1 - Frontend Flutter

## Descripción general

Este proyecto Flutter es la aplicación frontend para el sistema de convocatorias de Bienestar Mi SENA. Incluye:

- Pantallas de inicio de sesión, registro y recuperación de contraseña.
- Gestión de convocatorias, empresas, líneas, departamentos, ciudades, intereses, requisitos y favoritos.
- Controladores HTTP para consumir el backend Node.js disponible en `http://localhost:4000/api/v1/`.
- Estado global con GetX.

## Correcciones aplicadas

- Se corrigieron rutas de activos de imagen en Flutter: todas las referencias `img/...` se cambiaron a `assets/img/...`, que es la ruta registrada en `pubspec.yaml`.
- Se reforzó la inicialización de controladores globales en `lib/main.dart`.
- Se validó que la aplicación usa `GetMaterialApp` en `lib/views/interface/principal.dart`.
- Se documentó la estructura de cada carpeta y archivo clave.

## Cómo ejecutar el frontend

1. Abre una terminal en `FRONTENT`.
2. Ejecuta:

```bash
flutter pub get
flutter run
```

3. Asegúrate de que el backend esté disponible en `http://localhost:4000/api/v1/`.

> Si el backend no está ejecutándose, las pantallas de login, registro y servicios HTTP mostrarán errores de conexión.

## Estructura del proyecto Flutter (`lib/`)

### `lib/main.dart`

- Punto de entrada de la app.
- Inicializa `WidgetsFlutterBinding`.
- Registra los controladores globales `Reactcontroller` y `FavoritesController` con `Get.put(..., permanent: true)`.
- Arranca la aplicación con la pantalla `Principal()`.

### `lib/views/interface/principal.dart`

- Define el `GetMaterialApp` principal.
- Configura el título de la app y desactiva el banner de debug.
- Establece `Login()` como pantalla inicial.

### `lib/views/login/login.dart`

- Pantalla de inicio de sesión.
- Valida campos de correo y contraseña.
- Envía solicitud POST a `http://localhost:4000/api/v1/auths/authenticate`.
- Guarda datos de usuario en `Reactcontroller`.
- Carga favoritos de usuario con `FavoritesController`.
- Navega a `Inicio()` después de iniciar sesión correctamente.

### `lib/views/registro/registro.dart`

- Pantalla para crear cuenta.
- Formulario y envío de datos al backend.
- Usa el logo cargado desde `assets/img/convo2.png`.

### `lib/views/recuperarContraseña/recuperarContraseña.dart`

- Pantalla para recuperar contraseña.
- Presenta formulario de correo y botón para solicitar recuperación.
- Usa el logo cargado desde `assets/img/convo2.png`.

### `lib/views/interface/inicio.dart`

- Pantalla principal después del login.
- Muestra carrusel de convocatorias y filtros por línea.
- Usa controladores `ConvocatoriasController`, `LineasController`, `Reactcontroller` y `FavoritesController`.
- Muestra estados de carga y mensajes de error cuando hay problemas con el backend.

## Carpetas principales

### `lib/controllers/`

Controladores que manejan la lógica de negocio y las peticiones HTTP.

- `reactController.dart`: estado global del usuario (ID, nombre, correo, rol, empresa).
- `favorites_controller.dart`: carga, agrega y elimina favoritos.
- `convocatorias.dart`: obtiene convocatorias desde el backend.
- `lineas_controller.dart`: obtiene las líneas de convocatoria.
- `interesController.dart`: controla intereses.
- `empresa_controller.dart`: controla datos de empresas.
- `entidadInstitucion_controller.dart`: controla entidades/instituciones.
- `departamentoController.dart`: controla departamentos.
- `cuidadController.dart`: controla ciudades.
- `publicoObjetivo_controller.dart`: controla público objetivo.
- `requirement_category_controller.dart`: controla categorías de requisitos.
- `requirementGruposController.dart`: controla grupos de requisitos.
- `requisitos_controller.dart`: controla requisitos.
- `requirement_check_controller.dart`: controla verificaciones de requisitos.
- `interesAdicionalConvocatoria_controller.dart`: controla intereses adicionales de convocatoria.
- `userInterest.dart`: controla intereses de usuario.
- `registro.dart`: controla el formulario de registro.
- `rol_controller.dart`: controla roles de usuario.

### `lib/models/`

Modelos de datos que representan los objetos que utiliza la app.

- `models/usuarioModel/usuariosModel.dart`: modelo de usuario.
- `models/registroUser/registro.dart`: modelo de registro.
- `models/convocatorias/convocatoriasModel.dart`: modelo de convocatoria.
- `models/linea/linea_model.dart`: modelo de línea.
- `models/empresaModel/empresa_model.dart`: modelo de empresa.
- `models/entidadInstitucion/entidadInstitucionModel.dart`: modelo de institución.
- `models/Departamentodepartamento.dart`: modelo de departamento.
- `models/cuidad/cuidad.dart`: modelo de ciudad.
- `models/interes/…` y `models/interesModel/…`: modelos de interés.
- `models/userInterest/userInterest.dart`: modelo de interés de usuario.
- `models/Favoritos/favoritos.dart`: modelo de favorito.
- `models/requerimientosChequeos/requirement_check.dart`: modelo de chequeo.
- `models/requirement_categoryModel/requirement_category.dart`: modelo de categoría de requisito.
- `models/grupoRequisitos/grupoRequisitos.dart`: modelo de grupo de requisitos.
- `models/requisitosModel/requisitos.dart`: modelo de requisito.
- `models/publicoObejtivoModel/publicoObjetivo.dart`: modelo de público objetivo.
- `models/rol/rol.dart`: modelo de rol.

### `lib/views/`

Pantallas organizadas por área funcional.

- `interface/`: inicio de app, dashboard y navegación principal.
  - `principal.dart`: configuración del app shell.
  - `homePrincipal.dart`: pantalla principal del panel.
  - `inicio.dart`: panel de descubrimiento de convocatorias.
- `login/`: inicio de sesión.
- `registro/`: registro de nuevo usuario.
- `recuperarContraseña/`: recuperación de contraseña.
- `convocatorias/`: CRUD de convocatorias.
- `empresa/`: CRUD de empresas.
- `entidadInstitucion/`: CRUD de instituciones.
- `departamento/`: CRUD de departamentos.
- `ciudad/`: CRUD de ciudades.
- `linea/`: CRUD de líneas.
- `interes/`: CRUD de intereses.
- `publicoObjetivo/`: CRUD de público objetivo.
- `RequirementCategory/`: CRUD de categorías de requisitos.
- `grupoRequisitos/`: CRUD de grupos de requisitos.
- `requisitos/`: CRUD de requisitos.
- `RequisitosCheck/`: manejo de chequeos de requisitos.
- `adicionalInteresConvocatoria/`: intereses adicionales por convocatoria.
- `favoritosCrud/`: CRUD de favoritos.
- `detalleConvocatori/`: detalle completo de cada convocatoria.
- `perfilUser/`: perfil de usuario.
- `userInterests/`: intereses asignados a usuarios.

### `lib/widgets/`

Componentes UI reutilizables.

- `header.dart`: cabecera con logo y barra de búsqueda.
- `carousel_convocatorias.dart`: carrusel de convocatorias en pantalla de inicio.

### `lib/utils/`

Utilidades de ayuda para la aplicación.

- `image_helper.dart`: funciones auxiliares para cargar y formatear imágenes.

## Dependencias importantes

- `get`: estado reactivo y navegación con GetX.
- `http`: llamadas HTTP al backend.
- `font_awesome_flutter`: iconos extra.
- `awesome_dialog`: diálogos estilo moderno.
- `url_launcher`: abrir enlaces externos.
- `carousel_slider`: carrusel de imágenes.

## Notas finales

- La aplicación se puede ejecutar correctamente después de corregir las rutas de imagen.
- El backend debe estar activo en `http://localhost:4000/api/v1/` para que las pantallas de login, favoritos y CRUD funcionen.
- El análisis de Flutter no reporta errores críticos, solo avisos de nombres de archivo en CamelCase y advertencias de `BuildContext` posteriores a `await`.

Si deseas, puedo continuar y aplicar correcciones adicionales a los avisos de lint para dejar el proyecto alineado con las buenas prácticas de Dart 3.
