import os

flags_c = [
    '-x',
    'c',
    '-std=c11',
    '-Wall',
    '-Wextra',
    '-Werror'
]

flags_cpp = [
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
    if kwargs['language'] == 'cfamily':
        basename = os.path.splitext(kwargs['filename'])[1]
        if basename == '.c' or basename == '.h':
            return {'flags': flags_c}
        elif basename == '.cpp' or basename == '.hpp':
            return {'flags': flags_cpp}
        else:
            return{}

    return {}
