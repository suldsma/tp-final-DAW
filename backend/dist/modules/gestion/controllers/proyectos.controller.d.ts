import { CreateProyectoDto } from "../dtos/input/create-proyecto.dto";
import { UpdateProyectoDto } from "../dtos/input/update-proyecto.dto";
import { EstadosProyectosEnum } from "../enums/estados-proyectos.enum";
import { ProyectosService } from "../services/proyectos.service";
export declare class ProyectosController {
    private readonly proyectosService;
    constructor(proyectosService: ProyectosService);
    crearProyecto(dto: CreateProyectoDto): Promise<{
        id: number;
    }>;
    actualizarProyecto(id: number, dto: UpdateProyectoDto): Promise<void>;
    obtenerProyectos(estado?: EstadosProyectosEnum): Promise<{
        id: number;
        nombre: string;
        estado: EstadosProyectosEnum;
        cliente: {
            id: number;
            nombre: string;
        };
    }[]>;
}
