{% set machine = salt["pillar.get"]("machine") %}
{%- if grains["osarch"] == "arm64" %}
{% set subpath = "arm64" %}
{%- else %}
{% set subpath = "x86_64" %}
{%- endif %}


{%- if subpath == "arm64" %}
install_pandoc:
  cmd.run:
    - name: brew install pandoc
    - runas: {{ machine.user.name }}

{% else %}
{% set pandoc = machine.downloads.intel.pandoc.split("/")[-1] %}

download_pandoc:
  cmd.run:
    - name: curl -LO {{ machine.downloads.intel.pandoc }}
    - cwd: /tmp
    - user: {{ machine.user.name }}

install_pandoc:
  cmd.run:
    - name: installer -pkg {{ pandoc }} -target /
    - cwd: /tmp
    - require:
      - cmd: download_pandoc
{%- endif %}

fix_/usr/local_permissions:
  cmd.run:
    - name: |
        chown -R {{ machine.user.name }}:admin /usr/local/*
        chown -R root:wheel /usr/local/texlive
