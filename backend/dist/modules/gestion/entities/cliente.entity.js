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
exports.ClienteEntity = void 0;
const typeorm_1 = require("typeorm");
const estados_clientes_enum_1 = require("../enums/estados-clientes.enum");
const proyecto_entity_1 = require("./proyecto.entity");
let ClienteEntity = class ClienteEntity {
};
exports.ClienteEntity = ClienteEntity;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], ClienteEntity.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'text', unique: true, nullable: false }),
    __metadata("design:type", String)
], ClienteEntity.prototype, "nombre", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'varchar', length: 150, nullable: true }),
    __metadata("design:type", String)
], ClienteEntity.prototype, "correo", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'varchar', length: 50, nullable: true }),
    __metadata("design:type", String)
], ClienteEntity.prototype, "telefono", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'enum', enum: estados_clientes_enum_1.EstadosClientesEnum, default: estados_clientes_enum_1.EstadosClientesEnum.ACTIVO }),
    __metadata("design:type", String)
], ClienteEntity.prototype, "estado", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => proyecto_entity_1.ProyectoEntity, (proyecto) => proyecto.cliente),
    __metadata("design:type", Array)
], ClienteEntity.prototype, "proyectos", void 0);
exports.ClienteEntity = ClienteEntity = __decorate([
    (0, typeorm_1.Entity)('clientes')
], ClienteEntity);
//# sourceMappingURL=cliente.entity.js.map