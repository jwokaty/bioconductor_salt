base:
  'machine:type:(primary|secondary)':
    - match: pillar
    - common.cronjobs
    - common.dirs
  'os:Ubuntu':
    - match: grain
    - common.linux
    - rlang.linux                               # install R
    - dependencies.bibtex                       # BioC destiny
    - dependencies.libsbml_cflags_libsbml_libs  # BioC rsbml
  'os:MacOS':
    - match: grain
    - common.mac.xquartz
    - common.mac.xvfb
    - common.mac.gfortran
    - common.mac.brew
    - common.mac.tool_binaries
    - common.mac.pip
    - common.mac.mactex
    - common.mac.pandoc
  'G@os:MacOS and J@machine:type:^(primary|secondary)$':
    - match: compound 
    - common.mac.fix_permissions
    - dependencies.java                         # CRAN rJava
    - rlang.mac                                 # install R
    - dependencies.cmake                        # CRAN nloptr
  'os:MacOS':
    - match: grain
    - dependencies.jags                         # BioC rjags
    - dependencies.macfuse                      # BioC Travel
    - dependencies.mono                         # BioC rawrr
    - dependencies.open_babel                   # BioC ChemmineOB
    - dependencies.viennarna                    # BioC GeneGA
  'machine:type:primary':
    - match: pillar
    - webserver
  'machine:env:dev':
    - match: grain
    - common.bbs
  '*':
    - dependencies.reticulate_python            # Bioc seqArchR
    - dependencies.quarto                       # Bioc BiocBook
