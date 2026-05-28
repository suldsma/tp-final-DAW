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
Object.defineProperty(exports, "__esModule", { value: true });
exports.TareaEntity = void 0;
const typeorm_1 = require("typeorm");
const estados_tareas_enum_1 = require("../enums/estados-tareas.enum");
const proyecto_entity_1 = require("./proyecto.entity");
let TareaEntity = class TareaEntity {
};
exports.TareaEntity = TareaEntity;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], TareaEntity.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'text', nullable: false }),
    __metadata("design:type", String)
], TareaEntity.prototype, "descripcion", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'enum', enum: estados_tareas_enum_1.EstadosTareasEnum, default: estados_tareas_enum_1.EstadosTareasEnum.PENDIENTE }),
    __metadata("design:type", String)
], TareaEntity.prototype, "estado", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => proyecto_entity_1.ProyectoEntity, (proyecto) => proyecto.tareas),
    (0, typeorm_1.JoinColumn)({ name: 'id_proyecto' }),
    __metadata("design:type", proyecto_entity_1.ProyectoEntity)
], TareaEntity.prototype, "proyecto", void 0);
exports.TareaEntity = TareaEntity = __decorate([
    (0, typeorm_1.Entity)('tareas')
], TareaEntity);
//# sourceMappingURL=tarea.entity.js.map