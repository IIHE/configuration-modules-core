# ${license-info}
# ${developer-info}
# ${author-info}
# ${build-info}

unique template components/icinga2/config-rpm;
include {'components/icinga2/functions'};
include {'components/icinga2/schema'};

# Package to install
"/software/packages" = pkg_repl("ncm-${project.artifactId}", "${no-snapshot-version}-${rpm.release}", "noarch");

"/software/components/icinga2/dependencies/pre" ?=  list ("spma");

"/software/components/icinga2/active" ?= true;
"/software/components/icinga2/dispatch" ?= true;
