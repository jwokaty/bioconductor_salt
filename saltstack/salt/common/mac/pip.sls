{% set machine = salt["pillar.get"]("machine") %}
{% set repo = salt["pillar.get"]("repo") %}
{%- if grains["osarch"] == "arm64" %}
{% set subpath = "arm64" %}
{%- else %}
{% set subpath = "x86_64" %}
{%- endif %}


install_pip_pkgs:
  cmd.run:
    - name: python3 -m pip install $(cat {{ machine.user.home }}/{{ machine.user.name }}/{{ repo.bbs.name }}/Ubuntu-files/22.04/pip_*.txt | awk '/^[^#]/ {print $1}')
    - runas: {{ machine.user.name }}
