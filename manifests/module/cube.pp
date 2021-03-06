# == Class: icingaweb2::module::cube
#
# Install and enable the cube module.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*git_revision*]
#   The cube module is installed by cloning the git repository. Set either a branch or a tag name, eg.
#   `master` or `v1.0.0`.
#
class icingaweb2::module::cube(
  $ensure        = 'present',
  $git_revision  = undef,
){

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_string($git_revision)

  icingaweb2::module {'cube':
    ensure         => $ensure,
    git_repository => 'https://github.com/Icinga/icingaweb2-module-cube.git',
    git_revision   => $git_revision,
  }
}