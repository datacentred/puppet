# Define a global $PATH
Exec {
  path => [
    '/bin/',
    '/sbin/',
    '/usr/bin/',
    '/usr/sbin/',
  ],
}

# Probe hiera for our class list
hiera_include('classes')
