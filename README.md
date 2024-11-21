Repositório para facilitar testes com aplicações e protocolos



![image](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

Necessário ter o terraform instalado
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli



Nas distribuições Ubuntu, o SELinux é aplicado pelo QEMU, mesmo quando está desabilitado globalmente, o que pode resultar em comportamentos inesperados.

O erro "Não foi possível abrir '/var/lib/libvirt/images/<FILE_NAME>': Permissão negada" pode ocorrer devido a isso.

Para resolver, verifique se a linha security_driver = "none" não está comentada no arquivo /etc/libvirt/qemu.conf. Em seguida, execute o comando sudo systemctl restart libvirtd para reiniciar o daemon do libvirt.

