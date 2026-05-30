import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UsuarioEntity } from '../entities/usuario.entity';
import { LoginDto } from '../dtos/input/login.dto';
import { EstadosUsuariosEnum } from '../enums/estados-usuarios.enum';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(UsuarioEntity)
    private readonly usuarioRepo: Repository<UsuarioEntity>,
    private readonly jwtService: JwtService
  ) {}

  async login(dto: LoginDto): Promise<{ token: string }> {
    
    const usuario = await this.usuarioRepo.findOne({ where: { usuario: dto.usuario } });

    if (!usuario) {
      throw new UnauthorizedException('Credenciales inválidas');
    }

    if (usuario.estado !== EstadosUsuariosEnum.ACTIVO) {
      throw new UnauthorizedException('El usuario no se encuentra activo en el sistema');
    }

    const passwordMatch = await bcrypt.compare(dto.clave, usuario.clave);
    if (!passwordMatch) {
      throw new UnauthorizedException('Credenciales inválidas');
    }

    const payload = { sub: usuario.id, usuario: usuario.usuario };
    const token = await this.jwtService.signAsync(payload);

    return { token };
  }
}