#!/bin/bash

# Caminho absoluto da pasta onde o script está localizado
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Muda para o diretório do script
cd "$SCRIPT_DIR" || exit 1

# Executa o playbook
ansible-playbook -i inventory.yml playbook.yml -u root --ask-pass \
  -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no"'
