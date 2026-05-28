import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { UsuarioEntity } from '../entities/usuario.entity';
import { LoginDto } from '../dtos/input/login.dto';
export declare class AuthService {
    private readonly usuarioRepo;
    private readonly jwtService;
    constructor(usuarioRepo: Repository<UsuarioEntity>, jwtService: JwtService);
    login(dto: LoginDto): Promise<{
        token: string;
    }>;
}
