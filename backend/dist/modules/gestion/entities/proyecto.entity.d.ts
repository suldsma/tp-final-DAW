import { EstadosProyectosEnum } from '../enums/estados-proyectos.enum';
import { ClienteEntity } from './cliente.entity';
import { TareaEntity } from './tarea.entity';
export declare class ProyectoEntity {
    id: number;
    nombre: string;
    estado: EstadosProyectosEnum;
    cliente: ClienteEntity;
    tareas: TareaEntity[];
}
