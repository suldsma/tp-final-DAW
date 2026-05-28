"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.EstadisticasService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const proyecto_entity_1 = require("../../gestion/entities/proyecto.entity");
const cliente_entity_1 = require("../../gestion/entities/cliente.entity");
const tarea_entity_1 = require("../../gestion/entities/tarea.entity");
const estados_proyectos_enum_1 = require("../../gestion/enums/estados-proyectos.enum");
const estados_tareas_enum_1 = require("../../gestion/enums/estados-tareas.enum");
let EstadisticasService = class EstadisticasService {
    constructor(proyectoRepo, clienteRepo, tareaRepo) {
        this.proyectoRepo = proyectoRepo;
        this.clienteRepo = clienteRepo;
        this.tareaRepo = tareaRepo;
    }
    async obtenerEstadisticas() {
        const proyectosActivos = await this.proyectoRepo.count({
            where: { estado: estados_proyectos_enum_1.EstadosProyectosEnum.ACTIVO },
        });
        const proyectosFinalizados = await this.proyectoRepo.count({
            where: { estado: estados_proyectos_enum_1.EstadosProyectosEnum.FINALIZADO },
        });
        const tareasPendientes = await this.tareaRepo.count({
            where: { estado: estados_tareas_enum_1.EstadosTareasEnum.PENDIENTE },
        });
        const tareasFinalizadas = await this.tareaRepo.count({
            where: { estado: estados_tareas_enum_1.EstadosTareasEnum.FINALIZADA },
        });
        const clientesActivos = await this.clienteRepo.count();
        const proyectosPorCliente = await this.proyectoRepo
            .createQueryBuilder('p')
            .leftJoin('p.cliente', 'c')
            .select('c.nombre', 'cliente')
            .addSelect('COUNT(p.id)', 'cantidad')
            .groupBy('c.nombre')
            .getRawMany();
        return {
            proyectosActivos,
            proyectosFinalizados,
            tareasPendientes,
            tareasFinalizadas,
            clientesActivos,
            proyectosPorCliente,
        };
    }
};
exports.EstadisticasService = EstadisticasService;
exports.EstadisticasService = EstadisticasService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(proyecto_entity_1.ProyectoEntity)),
    __param(1, (0, typeorm_1.InjectRepository)(cliente_entity_1.ClienteEntity)),
    __param(2, (0, typeorm_1.InjectRepository)(tarea_entity_1.TareaEntity)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], EstadisticasService);
//# sourceMappingURL=estadisticas.service.js.map