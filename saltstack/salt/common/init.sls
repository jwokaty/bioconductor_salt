{% set machine = salt["pillar.get"]("machine") %}
{% set repo = salt["pillar.get"]("repo") %}


git_clone_{{ repo.bbs.name }}_to_{{ machine.user.home }}/{{ machine.user.name }}:
  git.cloned:
    - name: {{ repo.bbs.github }}
    - target: {{ machine.user.home }}/{{ machine.user.name }}/{{ repo.bbs.name }}
    - user: {{ machine.user.name }}
