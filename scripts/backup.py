import os
import subprocess
from datetime import datetime

def realizar_backup(database, usuario, senha, host='localhost', porta=5432, diretorio_backup='./backups'):
    """
    Realiza um backup completo do banco de dados PostgreSQL.

    Args:
        database (str): Nome do banco de dados.
        usuario (str): Nome do usuário do banco de dados.
        senha (str): Senha do usuário do banco de dados.
        host (str, optional): Host do servidor PostgreSQL. Defaults to 'localhost'.
        porta (int, optional): Porta do servidor PostgreSQL. Defaults to 5432.
        diretorio_backup (str, optional): Diretório para salvar os backups. Defaults to './backups'.
    """

    # Cria o diretório de backups se não existir
    os.makedirs(diretorio_backup, exist_ok=True)

    # Gera o nome do arquivo de backup com data e hora
    data_hora = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    nome_arquivo = f"backup_{database}_{data_hora}.dump"
    caminho_completo = os.path.join(diretorio_backup, nome_arquivo)

    # Comando para realizar o backup
    comando = f"pg_dump -h {host} -p {porta} -U {usuario} -Fc {database} > {caminho_completo}"

    try:
        # Executa o comando e captura a saída
        resultado = subprocess.run(comando, shell=True, capture_output=True, text=True)

        if resultado.returncode == 0:
            print(f"Backup realizado com sucesso em: {caminho_completo}")
        else:
            print(f"Erro ao realizar o backup: {resultado.stderr}")
    except subprocess.CalledProcessError as e:
        print(f"Erro ao executar o comando: {e}")

# Exemplo de uso:
database = "ProjetoBD"
usuario = "postgres"
senha = "rrmv2003"
realizar_backup(database, usuario, senha)