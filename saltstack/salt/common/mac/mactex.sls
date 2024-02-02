{% set machine = salt["pillar.get"]("machine") %}


download_mactex:
  cmd.run:
    - name: curl -LO {{ machine.downloads.mactex }}
    - cwd: /tmp
    - runas: {{ machine.user.name }}

install_mactex:
  cmd.run:
    - name: installer -pkg MacTeX.pkg -target /
    - cwd: /tmp
    - require:
      - cmd: download_mactex
