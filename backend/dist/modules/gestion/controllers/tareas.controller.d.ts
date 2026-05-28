import { CreateTareaDto } from "../dtos/input/create-tarea.dto";
import { UpdateTareaDto } from "../dtos/input/update-tarea.dto";
import { TareasService } from "../services/tareas.service";
export declare class TareasController {
    private readonly tareasService;
    constructor(tareasService: TareasService);
    crearTarea(dto: CreateTareaDto): Promise<{
        id: number;
    }>;
    actualizarTarea(id: number, dto: UpdateTareaDto): Promise<void>;
    eliminarTarea(id: number): Promise<void>;
    obtenerTareas(idProyecto?: number): Promise<{
        id: number;
        descripcion: string;
        estado: import("../enums/estados-tareas.enum").EstadosTareasEnum;
        proyecto: {
            id: number;
            nombre: string;
        };
    }[]>;
}
