{% set machine = salt["pillar.get"]("machine") %}

brew_packages:
  cmd.run:
    - name: brew install {{ machine.brews }}
    - runas: {{ machine.user.name }}
