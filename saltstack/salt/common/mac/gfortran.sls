{% set machine = salt["pillar.get"]("machine") %}
{% set gfortran_download = machine.downloads.gfortran %}
{% set gfortran = machine.downloads.gfortran.split("/")[-1] %}


download_gfortran:
  cmd.run:
    - name: curl -LO {{ gfortran_download }}
    - cwd: {{ machine.user.home }}/{{ machine.user.name }}/Downloads
    - runas: {{ machine.user.name }}

install_gfortran:
  cmd.run:
    - name: tar -xf {{ machine.user.home }}/{{ machine.user.name }}/Downloads/{{ gfortran }} -C /
    - require:
      - cmd: download_gfortran

export_gfortran_path:
  file.append:
    - name: /etc/profile
    - text: |
        export PATH=$PATH:/opt/gfortran/bin
    - require:
      - cmd: install_gfortran

symlink_gfortran_sdk:
  cmd.run:
    - name: ln -sfn $(xcrun --show-sdk-path) /opt/gfortran/SDK
    - require:
      - file: export_gfortran_path
