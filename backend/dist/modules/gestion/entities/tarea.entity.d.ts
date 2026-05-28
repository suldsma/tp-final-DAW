import { EstadosTareasEnum } from '../enums/estados-tareas.enum';
import { ProyectoEntity } from './proyecto.entity';
export declare class TareaEntity {
    id: number;
    descripcion: string;
    estado: EstadosTareasEnum;
    proyecto: ProyectoEntity;
}
