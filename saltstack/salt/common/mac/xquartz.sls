{% set machine = salt["pillar.get"]("machine") %}
{% set xquartz = machine.downloads.xquartz.split("/")[-1] %}


download_XQuartz:
  cmd.run:
    - name: curl -LO {{ machine.downloads.xquartz }}
    - cwd: /tmp

install_XQuartz:
  cmd.run:
    - name: |
        installer -pkg {{ xquartz }} -target /
    - cwd: /tmp
    - require:
      - cmd: download_XQuartz

symlink_x11:
  cmd.run:
    - name: ln -s /opt/X11/include/X11 X11
    - cwd: /usr/local/include
    - require:
      - cmd: install_XQuartz
