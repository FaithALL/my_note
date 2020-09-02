flags = [
'-x',
'c++',
'-std=c++14',
'-Wall',
'-Wextra',
'-Werror'
]


def Settings( **kwargs ):
  return {
    'flags': flags,
  }
