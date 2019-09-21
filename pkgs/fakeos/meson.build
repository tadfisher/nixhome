project('fakeos', 'c',
  version : '0.1',
  default_options : ['warning_level=3'])

xdg_basedir = dependency('libxdg-basedir')

lib = library('fakeos', 'fakeos.c',
  install : true,
  gnu_symbol_visibility : 'hidden',
  dependencies : [ xdg_basedir ],
  link_args : ['-ldl']
)
