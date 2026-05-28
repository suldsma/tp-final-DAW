import { EstadisticasService } from '../services/estadisticas.service';
export declare class EstadisticasController {
    private readonly estadisticasService;
    constructor(estadisticasService: EstadisticasService);
    obtenerEstadisticas(): Promise<{
        proyectosActivos: number;
        proyectosFinalizados: number;
        tareasPendientes: number;
        tareasFinalizadas: number;
        clientesActivos: number;
        proyectosPorCliente: any[];
    }>;
}
