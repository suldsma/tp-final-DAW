"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.EstadisticasModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const auth_module_1 = require("../auth/auth.module");
const estadisticas_controller_1 = require("./controllers/estadisticas.controller");
const estadisticas_service_1 = require("./services/estadisticas.service");
const proyecto_entity_1 = require("../gestion/entities/proyecto.entity");
const cliente_entity_1 = require("../gestion/entities/cliente.entity");
const tarea_entity_1 = require("../gestion/entities/tarea.entity");
let EstadisticasModule = class EstadisticasModule {
};
exports.EstadisticasModule = EstadisticasModule;
exports.EstadisticasModule = EstadisticasModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forFeature([
                proyecto_entity_1.ProyectoEntity,
                cliente_entity_1.ClienteEntity,
                tarea_entity_1.TareaEntity,
            ]),
            auth_module_1.AuthModule,
        ],
        controllers: [estadisticas_controller_1.EstadisticasController],
        providers: [estadisticas_service_1.EstadisticasService],
    })
], EstadisticasModule);
//# sourceMappingURL=estadisticas.module.js.map