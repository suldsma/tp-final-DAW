import { EstadosClientesEnum } from '../enums/estados-clientes.enum';
import { ProyectoEntity } from './proyecto.entity';
export declare class ClienteEntity {
    id: number;
    nombre: string;
    estado: EstadosClientesEnum;
    proyectos: ProyectoEntity[];
}
