import { EstadosClientesEnum } from "../../enums/estados-clientes.enum";
export declare class ListClienteDTO {
    id: number;
    nombre: string;
    correo?: string;
    telefono?: string;
    estado: EstadosClientesEnum;
}
