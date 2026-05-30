"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GestionModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const auth_module_1 = require("../auth/auth.module");
const clientes_controller_1 = require("./controllers/clientes.controller");
const proyectos_controller_1 = require("./controllers/proyectos.controller");
const tareas_controller_1 = require("./controllers/tareas.controller");
const clientes_service_1 = require("./services/clientes.service");
const proyectos_service_1 = require("./services/proyectos.service");
const tareas_service_1 = require("./services/tareas.service");
const cliente_entity_1 = require("./entities/cliente.entity");
const proyecto_entity_1 = require("./entities/proyecto.entity");
const tarea_entity_1 = require("./entities/tarea.entity");
let GestionModule = class GestionModule {
};
exports.GestionModule = GestionModule;
exports.GestionModule = GestionModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forFeature([cliente_entity_1.ClienteEntity, proyecto_entity_1.ProyectoEntity, tarea_entity_1.TareaEntity]),
            auth_module_1.AuthModule
        ],
        controllers: [clientes_controller_1.ClientesController, proyectos_controller_1.ProyectosController, tareas_controller_1.TareasController],
        providers: [clientes_service_1.ClientesService, proyectos_service_1.ProyectosService, tareas_service_1.TareasService],
        exports: [tareas_service_1.TareasService, proyectos_service_1.ProyectosService, clientes_service_1.ClientesService],
    })
], GestionModule);
//# sourceMappingURL=gestion.module.js.map