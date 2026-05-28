import { Repository } from 'typeorm';
import { ProyectoEntity } from '../../gestion/entities/proyecto.entity';
import { ClienteEntity } from '../../gestion/entities/cliente.entity';
import { TareaEntity } from '../../gestion/entities/tarea.entity';
export declare class EstadisticasService {
    private readonly proyectoRepo;
    private readonly clienteRepo;
    private readonly tareaRepo;
    constructor(proyectoRepo: Repository<ProyectoEntity>, clienteRepo: Repository<ClienteEntity>, tareaRepo: Repository<TareaEntity>);
    obtenerEstadisticas(): Promise<{
        proyectosActivos: number;
        proyectosFinalizados: number;
        tareasPendientes: number;
        tareasFinalizadas: number;
        clientesActivos: number;
        proyectosPorCliente: any[];
    }>;
}
