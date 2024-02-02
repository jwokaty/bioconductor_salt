{% set machine = salt["pillar.get"]("machine") %}
{% set repo = salt["pillar.get"]("repo") %}


install_pip_pkgs:
  cmd.run:
    - name: python3 -m pip install $(cat {{ repo.bbs.name }}/Ubuntu-files/22.04/pip_*.txt | awk '/^[^#]/ {print $1}')
    - runas: {{ machine.user.name }}
