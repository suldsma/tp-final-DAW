import { Repository } from 'typeorm';
import { TareaEntity } from '../entities/tarea.entity';
import { ProyectoEntity } from '../entities/proyecto.entity';
import { CreateTareaDto } from '../dtos/input/create-tarea.dto';
import { UpdateTareaDto } from '../dtos/input/update-tarea.dto';
import { EstadosTareasEnum } from '../enums/estados-tareas.enum';
export declare class TareasService {
    private readonly tareaRepo;
    private readonly proyectoRepo;
    constructor(tareaRepo: Repository<TareaEntity>, proyectoRepo: Repository<ProyectoEntity>);
    crearTarea(dto: CreateTareaDto): Promise<{
        id: number;
    }>;
    actualizarEstado(id: number, estado: EstadosTareasEnum): Promise<TareaEntity>;
    obtenerTareas(idProyecto?: number): Promise<TareaEntity[]>;
    actualizarTarea(id: number, dto: UpdateTareaDto): Promise<void>;
    eliminarTarea(id: number): Promise<void>;
}
