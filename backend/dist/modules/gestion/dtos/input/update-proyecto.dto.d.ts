import { EstadosProyectosEnum } from '../../enums/estados-proyectos.enum';
export declare class UpdateProyectoDto {
    nombre?: string;
    idCliente?: number;
    estado?: EstadosProyectosEnum;
    fechaFinalizacion?: string;
}
