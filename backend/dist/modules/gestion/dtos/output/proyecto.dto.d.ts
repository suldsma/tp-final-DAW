import { EstadosProyectosEnum } from "../../enums/estados-proyectos.enum";
import { ListTareaDTO } from "./list-tarea.dto";
export declare class ProyectoDTO {
    id: number;
    nombre: string;
    estado: EstadosProyectosEnum;
    cliente: {
        id: number;
        nombre: string;
    } | null;
    tareas: ListTareaDTO[];
}
