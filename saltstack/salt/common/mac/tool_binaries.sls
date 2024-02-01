{% set machine = salt["pillar.get"]("machine") %}
{%- if grains["osarch"] == "arm64" %}
{% set subpath = "arm64" %}
{%- else %}
{% set subpath = "x86_64" %}
{%- endif %}


{%- for binary in machine.binaries %}
install_{{ binary }}:
  cmd.run:
    - name: |
        sudo Rscript -e "source('https://mac.R-project.org/bin/install.R'); install.libs('{{ binary }}')"
{%- endfor %}

append_openssl_configurations_to_path:
  file.append:
    - name: /etc/profile
    - text: |
        export PATH=$PATH:/opt/R/{{ subpath }}/bin
        export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/R/{{ subpath }}/lib/pkgconfig
        export OPENSSL_LIBS="/opt/R/{{ subpath }}/lib/libssl.a /opt/R/{{ subpath }}/lib/libcrypto.a"
