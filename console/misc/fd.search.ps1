hr
# base dir where the app's base is set
# search-path is now running relative base dir
fd -e ps1 --base-directory (gi ..) --search-path 'console'
hr
# so the same might be
fd -e ps1 --search-path (gi '../console')
