import { EstadosTareasEnum } from '../../enums/estados-tareas.enum';
export declare class UpdateTareaDto {
    descripcion?: string;
    estado?: EstadosTareasEnum;
    idProyecto?: number;
}
