import { Repository } from 'typeorm';
import { ProyectoEntity } from '../entities/proyecto.entity';
import { ClienteEntity } from '../entities/cliente.entity';
import { CreateProyectoDto } from '../dtos/input/create-proyecto.dto';
import { UpdateProyectoDto } from '../dtos/input/update-proyecto.dto';
import { EstadosProyectosEnum } from '../enums/estados-proyectos.enum';
export declare class ProyectosService {
    private readonly proyectoRepo;
    private readonly clienteRepo;
    constructor(proyectoRepo: Repository<ProyectoEntity>, clienteRepo: Repository<ClienteEntity>);
    crearProyecto(dto: CreateProyectoDto): Promise<{
        id: number;
    }>;
    actualizarProyecto(id: number, dto: UpdateProyectoDto): Promise<void>;
    obtenerProyectos(estado?: EstadosProyectosEnum): Promise<ProyectoEntity[]>;
}
