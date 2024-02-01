{# Custom Settings #}

{% set branch = 'release' %}                {# Use 'release' or 'devel' #}
{% set version = '3.14' %}                  {# Bioc version #}
{% set environment = 'dev' %}               {# Use 'dev' or 'prod' #}
{% set cycle = 'patch' %}                   {# Use 'devel' for Spring to Fall, 'patch' for Fall to Spring #}
{% set name = 'nebbiolo2' %}                {# nebbiolo1 for 3.15, nebbiolo2 for 3.14 #}

{# For Macs
   If installing R devel, download R the .pkg file from https://mac.r-project.org.
   If installing R release, download the .pkg file from https://cloud.r-project.org/bin/macosx/.
#}

{% set r_download = 'https://cran.r-project.org/src/base/R-4/R-4.1.1.tar.gz' %}
{% set r_version = 'R-4.1.1' %}

{# Add any pillars to overwrite existing values #}

{# Bioc package dependencies #}

{% set immunespace_pwd = '' %}              {# Need for ImmuneSpaceR #}
