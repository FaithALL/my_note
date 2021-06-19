flags = [
    '-x',
    'c++',
    '-std=c++17',
    '-Wall',
    '-Wextra',
    '-Werror',
    '-isystem', '/usr/include/c++/9',
    '-isystem', '/usr/include/x86_64-linux-gnu/c++/9',
    '-isystem', '/usr/local/include',
    '-isystem', '/usr/include',
]


def Settings(**kwargs):
    return {
        'flags': flags,
    }
