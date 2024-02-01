# Note: This is only for the BBS

{% set machine = salt["pillar.get"]("machine") %}


remove_chown-rootadmin:
  file.absent:
    - name: {{ machine.user.home }}/{{ machine.user.name }}/BBS/utils/chown-rootadmin

run_chown-rootadmin:
  cmd.run:
    - name: gcc chown-rootadmin.c -o chown-rootadmin
    - runas: {{ machine.user.name }}
    - cwd: {{ machine.user.home }}/{{ machine.user.name }}/BBS/utils

fix_chown-rootadmin_permissions:
  cmd.run:
    - name: |
        chown root:admin chown-rootadmin
        chmod 4750 chown-rootadmin
    - cwd: {{ machine.user.home }}/{{ machine.user.name }}/BBS/utils
    - require:
      - cmd: run_chown-rootadmin
