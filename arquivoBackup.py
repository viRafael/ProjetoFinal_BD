import psycopg2
import os
from datetime import datetime
import time  # Importe o módulo time

# Dados de conexão com o banco de dados
conn_params = {
    'host': 'localhost',
    'port': 5432,
    'database': 'ProjetoBD',
    'user': 'postgres',
    'password': 'rrmv2003'
}

# Diretório local para o backup
DIR_LOCAL = "C:\\Users\\alessandra.jesus\\Desktop"

def full_backup():
  """Realiza o full backup do banco de dados."""

  try:
    # Conecta ao banco de dados
    conn = psycopg2.connect(**conn_params)
    conn.autocommit = True
    cur = conn.cursor()

    # Data e hora do backup
    data_hora = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    arquivo_backup = os.path.join(DIR_LOCAL, f"full_backup_{data_hora}.sql")

    # Comando pg_dump
    comando = f"pg_dump -h {conn_params['host']} -p {conn_params['port']} -U {conn_params['user']} -Fc {conn_params['database']} > {arquivo_backup}"
    os.system(comando)

    print(f"Full backup realizado com sucesso em {arquivo_backup}")

    # Limpeza (opcional): remover backups antigos do disco local
    for arquivo in os.listdir(DIR_LOCAL):
      if arquivo.startswith("full_backup_") and arquivo.endswith(".sql"):
        caminho_arquivo = os.path.join(DIR_LOCAL, arquivo)
        if os.path.getmtime(caminho_arquivo) < time.time() - (7 * 24 * 60 * 60):  # 7 dias em segundos
          os.remove(caminho_arquivo)
          print(f"Backup antigo removido: {caminho_arquivo}")

  except Exception as e:
    print(f"Erro ao realizar o full backup: {e}")
  finally:
    if conn:
      cur.close()
      conn.close()

if __name__ == "__main__":
  full_backup()