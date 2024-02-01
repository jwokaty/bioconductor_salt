{% set machine = salt["pillar.get"]("machine") %}


download_mactex:
  cmd.run:
    - name: curl -LO {{ machine.downloads.mactex }}
    - cwd:  {{ machine.user.home }}/{{ machine.user.name }}/Downloads
    - runas: {{ machine.user.name }}

install_mactex:
  cmd.run:
    - name: installer -pkg MacTeX.pkg -target /
    - cwd:  {{ machine.user.home }}/{{ machine.user.name }}/Downloads
    - require:
      - cmd: download_mactex
