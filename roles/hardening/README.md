HARDENING
=========

### Uma breve descrição sobre o uso dessa Role.
As tasks dessa role foram feitas com base na documentação [Manual de Hardening para Linux Red Hat Enterprise] disponibilizada pelo time de Segurança.

**ADD LINK DA DOC**

Requerimentos
------------

- Necessário python3 (RHEL 8) ou python (RHEL 7)
- Ansible 2.9+

- Adicionar o parametro `remote_tmp = /tmp`  no arquivo `ansible.cfg`
 - EBS adicional e montagem /home e /var/log no novo disco.
 
 Exemplo de ficam as partições:

````bash
# parted -l
Model: NVMe Device (nvme)
Disk /dev/nvme0n1: 37.6GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  2097kB  1049kB                     bios_grub
 2      2097kB  37.6GB  37.6GB  xfs


Model: NVMe Device (nvme)
Disk /dev/nvme1n1: 32.2GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name     Flags
 1      1074MB  10.0GB  8926MB  ext4         primary
 2      10.0GB  21.5GB  11.5GB  ext4         primary

````
Exemplo de montagem de filesystem:
````bash
[root@svp03600hrdg02 ~]# df -hl
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        877M     0  877M   0% /dev
tmpfs           900M     0  900M   0% /dev/shm
tmpfs           900M   17M  884M   2% /run
tmpfs           900M     0  900M   0% /sys/fs/cgroup
/dev/nvme0n1p2   35G  2.8G   33G   8% /
tmpfs           900M  284K  900M   1% /tmp
/dev/nvme1n1p2   11G   45M  9.9G   1% /var/log
/dev/nvme1n1p1  8.1G   37M  7.6G   1% /home
tmpfs           180M     0  180M   0% /run/user/1000
````
 
Como base foi usada a seguinte imagem base AWS na conta *shared*.
- RHEL7: `ami-06501af02091f3351`
- RHEL8: `ami-0c2485d67d416fc4f`

Foi necessário um segundo EBS para montagem do diretório `/home` e `/var/log`.

AMIs usadas com EBS já adicionados e com mounts prontos para testes:
- RHEL7: `ami-02fb1a8f636195344`
- RHEL8: `ami-028dd15e8fac5bc7d`


Role Variables
--------------
As variáveis necessárias estão declaradas no arquivo `/defaults/main.yaml`

Dependencies
------------

- Collection community.general 
````
ansible-galaxy collection install community.general
````

Example Playbook
----------------

Exemplo de playbook chamando a role:
````yaml
    - hosts: g_aws_hardening
      vars:
      become: yes
      gather_facts: yes
      roles:
        - { role: hardening }
````        
Exemplo de AD HOC command para execução:
````
ansible-playbook --private-key ~/.ssh/key-hardening-sa-east-1-prd.pem --user ec2-user site.yml
````
License
-------

BSD

Author Information
------------------
Allyson Medeiros
