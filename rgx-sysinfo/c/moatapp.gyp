{
  'targets': [
    {
      'target_name': '<(package_name)',
      'sources': [ 
	      'src/<(package_name).c'
      ],
      'product_prefix': '',
      'type': 'shared_library',
      'cflags': [ '-fPIC' ],
      'include_dirs' : [
      ],
      'libraries': [
	      '-lev',
	      '-luuid'
      ],
      'dependencies': [ 'sysinfo', 'moatapp' ],
    },

# daemon program using 'libsysinfo'.
    {
      'target_name': 'sysinfo_daemon',
      'type': 'executable',
      'clfags' : [],
      'sources': [ 'src/sysinfo_daemon.c' ],
      'libraries': [
      	'-lev',
        '-luuid',
      ],
      'dependencies': [ 'sysinfo', 'moatapp' ],
    },

# Sensor Device Management System static library for libangora.
    {
      'target_name': 'sysinfo',
      'product_prefix': 'lib',
      'type': 'static_library',
      'cflags': [
      ],
      'sources': [
	      'src/sysinfo.c',
      ],
    },

# moat stub
    {
      'target_name': 'moatapp',
      'product_prefix': 'lib',
      'type': 'shared_library',
      'cflags': [ '-fPIC' ],
      'sources': [
        'stub/stub__moatapp.c',
      ],
    },

    {
      'target_name': 'test',
      'type': 'executable',
      'dependencies': [ 'moatapp', '<(package_name)' ],
      'sources': [ 'test/test.c' ]
    },
  ],
}
