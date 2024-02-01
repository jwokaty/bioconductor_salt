# Copy salt files into /srv/salt
# Place biocbuild ssh key into /srv/salt/common/files
# Place an authorized_keys file with core team member public keys in /srv/salt/common/files

{% set machine = salt["pillar.get"]("machine") %}
{% set repo = salt["pillar.get"]("repo") %}


install_apt_pkgs:
  cmd.run:
    - name: DEBIAN_FRONTEND=noninteractive apt-get -y install $(cat /home/{{ machine.user.name }}/{{ repo.bbs.name }}/{{ grains["os"] }}-files/{{ grains["osrelease"] }}/apt_*.txt | awk '/^[^#]/ {print $1}')

update_pip:
  cmd.run:
    - name: pip install --upgrade pip 

install_pip_pkgs:
  cmd.run:
    - name: python3 -m pip install $(cat /home/{{ machine.user.name }}/{{ repo.bbs.name }}/{{ grains["os"] }}-files/{{ grains["osrelease"] }}/pip_*.txt | awk '/^[^#]/ {print $1}')

check_locale:
  locale.present:
    - name: en_US.UTF-8
    - onlyif: ls /usr/share/i18n/locales

change_date_to_24_hours:
  cmd.run:
    - name: "locale-gen 'en_GB'; update-locale LC_TIME='en_GB'"
    - onchanges:
      - locale: check_locale

{%- if machine.type != "standalone" %}
change_time_to_edt:
  cmd.run:
    - name: timedatectl set-timezone America/New_York
    - onchanges:
      - locale: check_locale
{%- endif %}

# Set up Xvfb
install_xvfb:
  pkg.installed:
    - name: xvfb

create_xfb_init:
  file.managed:
    - name: /etc/init.d/xvfb
    - mode: 755
    - contents: |
        #! /bin/sh
        ### BEGIN INIT INFO
        # Provides:          Xvfb
        # Required-Start:    $remote_fs $syslog
        # Required-Stop:     $remote_fs $syslog
        # Default-Start:     2 3 4 5
        # Default-Stop:      0 1 6
        # Short-Description: Loads X Virtual Frame Buffer
        # Description:       This file should be used to construct scripts to be
        #                    placed in /etc/init.d.
        #
        #                    A virtual X server is needed to non-interactively run
        #                    'R CMD build' and 'R CMD check on some BioC packages.
        #                    The DISPLAY variable is set in /etc/profile.d/xvfb.sh.
        ### END INIT INFO
       
        XVFB=/usr/bin/Xvfb
        XVFBARGS=":1 -screen 0 800x600x16"
        PIDFILE=/var/run/xvfb.pid
        case "$1" in
          start)
            echo -n "Starting virtual X frame buffer: Xvfb"
            start-stop-daemon --start --quiet --pidfile $PIDFILE --make-pidfile --background --exec $XVFB -- $XVFBARGS
            echo "."
            ;;
          stop)
            echo -n "Stopping virtual X frame buffer: Xvfb"
            start-stop-daemon --stop --quiet --pidfile $PIDFILE

            sleep 2
            rm -f $PIDFILE
            echo "."
            ;;
          restart)
            $0 stop
            $0 start
            ;;
          *)
            echo "Usage: /etc/init.d/xvfb {start|stop|restart}"
            exit 1
        esac

        exit 0

install_init-system-helpers:
  pkg.installed:
    - name: init-system-helpers

symlink_xvfb:
  cmd.run:
    - name: update-rc.d xvfb defaults

check_xvfb_running:
  service.running:
    - name: xvfb
    - enable: True

set_xvfb_display_env:
  file.managed:
    - name: /etc/profile.d/xvfb.sh
    - mode: 644
    - contents: |
        ## Set DISPLAY environment variable for use with Xvfb.
        ## See /etc/init.d/xvfb for start / stop configuration.
        export DISPLAY=:1.0

# For installing Perl modules noninteractively
add_PERL_MM_USE_DEFAULT_to_bashrc:
  file.append:
    - name: /root/.bashrc
    - text: export PERL_MM_USE_DEFAULT=1
