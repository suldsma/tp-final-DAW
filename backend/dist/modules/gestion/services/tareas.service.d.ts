import { Repository } from 'typeorm';
import { TareaEntity } from '../entities/tarea.entity';
import { ProyectoEntity } from '../entities/proyecto.entity';
import { CreateTareaDto } from '../dtos/input/create-tarea.dto';
import { UpdateTareaDto } from '../dtos/input/update-tarea.dto';
export declare class TareasService {
    private readonly tareaRepo;
    private readonly proyectoRepo;
    constructor(tareaRepo: Repository<TareaEntity>, proyectoRepo: Repository<ProyectoEntity>);
    crearTarea(dto: CreateTareaDto): Promise<{
        id: number;
    }>;
    actualizarTarea(id: number, dto: UpdateTareaDto): Promise<void>;
    eliminarTarea(id: number): Promise<void>;
    obtenerTareas(idProyecto?: number): Promise<TareaEntity[]>;
}
