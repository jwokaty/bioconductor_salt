{# Run Xvfb as a service #}

create_xvfb_plist:
  file.managed:
    - name: /Library/LaunchDaemons/local.xvfb.plist
    - contents: |
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>KeepAlive</key>
              <true/>
            <key>Label</key>
              <string>local.xvfb</string>
            <key>ProgramArguments</key>
              <array>
                <string>/opt/X11/bin/Xvfb</string>
                <string>:1</string>
                <string>-screen</string>
                <string>0</string>
                <string>800x600x16</string>
              </array>
            <key>RunAtLoad</key>
              <true/>
            <key>ServiceDescription</key>
              <string>Xvfb Virtual X Server</string>
            <key>StandardOutPath</key>
              <string>/var/log/xvfb/xvfb.stdout.log</string>
            <key>StandardErrorPath</key>
              <string>/var/log/xvfb/xvfb.stderror.log</string>
          </dict>
        </plist>

create_xvfb.conf:
  file.managed:
    - name: /etc/newsyslog.d/xvfb.conf
    - contents: |
        # logfilename          [owner:group]    mode count size when  flags [/pid_file] [sig_num]
        /var/log/xvfb/xvfb.stderror.log         644  5     5120 *     JN
        /var/log/xvfb/xvfb.stdout.log           644  5     5120 *     JN
    - require:
      - file: create_xvfb_plist

simulate_rotation:
  cmd.run:
    - name: newsyslog -nvv
    - require:
      - file: create_xvfb.conf

export_global_variable_DISPLAY:
  file.append:
    - name: /etc/profile
    - text: export DISPLAY=:1.0
    - require:
      - file: create_xvfb.conf

load_xvfb:
  cmd.run:
    - name: launchctl load /Library/LaunchDaemons/local.xvfb.plist
    - require:
      - file: export_global_variable_DISPLAY
