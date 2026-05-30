### Backend - Sistema de Gestión de Proyectos

Este es el backend del Sistema de Gestión de Proyectos, desarrollado con NestJS, TypeScript y TypeORM. Provee la API REST necesaria para la gestión de clientes, proyectos, tareas y estadísticas.

---

## 🔑 Credenciales de Acceso de Prueba

Para ingresar al sistema desde la pantalla de Login, utilice los siguientes datos:

- **Usuario:** usuario
- **Contraseña:** clave

---

## 🛠️ Instrucciones para Configurar la Base de Datos

Para levantar la base de datos de forma local, siga estos pasos:

1. Abra **pgAdmin 4** y cree una base de datos vacía llamada `gestion_proyectos`.
2. Haga clic derecho sobre la base de datos creada y seleccione **Query Tool**.
3. Copie todo el contenido del archivo `entrega_final_bd.sql` (ubicado en la raíz de este proyecto) y péguelo en la consola de pgAdmin.
4. Presione **F5** (o el botón Ejecutar). Esto creará la estructura completa del sistema y cargará de forma automática el usuario administrador de prueba.

---

## 🚀 Tecnologías

Framework: NestJS

Lenguaje: TypeScript

Base de Datos: (Ej: PostgreSQL/MySQL)

Validación: class-validator, class-transformer

Documentación: Swagger (OpenAPI)

---

## ⚙️ Configuración

cd backend
npm install

---

## .env

PORT=3000
DB_HOST=localhost
DB_PORT=5433
DB_USERNAME=postgres
DB_PASSWORD=1234
DB_NAME=gestion_proyectos
DB_LOGGING=true
SWAGGER_HABILITADO=true
JWT_SECRET="gtT0zY6&5Sx%7c29x&O4@^@73D&uz^xQ"

---

## 🏃‍♂️ Ejecución

Desarrollo
Para ejecutar el servidor en modo observación (recarga automática):
npm run start:dev

Producción
Para compilar y ejecutar el servidor:
npm run build
npm run start:prod

Nota: SWAGGER_HABILITADO=true, puedes acceder a la documentación interactiva en http://localhost:3000/api

---

## 🛠️ Estructura del Proyecto

src/: Código fuente principal.

auth/: Gestión de seguridad y Guards.

gestion/: Módulos de clientes, proyectos y tareas.

estadisticas/: Lógica de reportes.

dtos/: Objetos de transferencia de datos.

entities/: Modelos de la base de datos (TypeORM).

---

## Este proyecto fue desarrollado como parte del Trabajo Final (TP) - DAW.

-GRUPO "A"

INTEGRANTES

- Andrea Natalia Segovia
- Benjamin Fibiger
- Susana Ester Ledesma
