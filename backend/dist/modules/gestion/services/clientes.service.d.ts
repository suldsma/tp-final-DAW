import { Repository } from 'typeorm';
import { ClienteEntity } from '../entities/cliente.entity';
import { CreateClienteDto } from '../dtos/input/create-cliente.dto';
import { UpdateClienteDto } from '../dtos/input/update-cliente.dto';
import { EstadosClientesEnum } from '../enums/estados-clientes.enum';
export declare class ClientesService {
    private readonly clienteRepo;
    constructor(clienteRepo: Repository<ClienteEntity>);
    crearCliente(dto: CreateClienteDto): Promise<{
        id: number;
    }>;
    obtenerClientes(estado?: EstadosClientesEnum): Promise<ClienteEntity[]>;
    actualizarCliente(id: number, dto: UpdateClienteDto): Promise<void>;
}
