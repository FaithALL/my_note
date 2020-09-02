flags = [
'-x',
'c',
'-std=c11',
'-Wall',
'-Wextra',
'-Werror'
]


def Settings( **kwargs ):
  return {
    'flags': flags,
  }
