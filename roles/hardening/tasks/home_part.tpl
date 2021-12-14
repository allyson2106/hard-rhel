
- name: Create a new primary partition with a size of 20GiB from HOME
  community.general.parted:
    device: /dev/nvme1n1
    number: 1
    state: present
    part_end: 10GiB
    fs_type: ext4
  
- name: Create a new primary partition with a size of 10GiB from var/log
  community.general.parted:
    device: /dev/nvme1n1
    number: 2
    state: present
    part_start: 11.5GB
    part_end: 20GB
    fs_type: ext4

- name: Create a directory /home2
  ansible.builtin.file:
    path: /home2
    state: directory

- name: Create a directory /var/log2
  ansible.builtin.file:
    path: /var/log2
    state: directory

- name: Mount up device by label
  ansible.posix.mount:
    path: /dev/nvme1n1p1
    src: /home2
    fstype: ext4
    state: present

- name: Mount up device by label
  ansible.posix.mount:
    path: /dev/nvme1n1p2
    src: /var/log2
    fstype: ext4
    state: present

- name: copy /home to /home2
  ansible.builtin.shell: cp -prv /home/* /home2/
  args:
    executable: /bin/bash

- name: copy /var/log to /varlog2
  ansible.builtin.shell: cp -prv /var/log/* /var/log2/
  args:
    executable: /bin/bash

#Passos realizados Manualmente.
# - name: rm -rf /home/
#   ansible.builtin.shell: rm -rf /home/*
#   args:
#     executable: /bin/bash

# - name: rm -rf /var/log 
#   ansible.builtin.shell: rm -rf /var/log/*
#   args:
#     executable: /bin/bash

# - name: Unmount a mounted volume
#   ansible.posix.mount:
#     path: /var/log2
#     state: unmounted

# - name: Unmount a mounted volume
#   ansible.posix.mount:
#     path: /home2
#     state: unmounted

# - name: Mount up device by label
#   ansible.posix.mount:
#     path: /dev/nvme1n1p1
#     src: /home
#     fstype: ext4
#     state: present

# - name: Mount up device by label
#   ansible.posix.mount:
#     path: /dev/nvme1n1p2
#     src: /var/log
#     fstype: ext4
#     state: present