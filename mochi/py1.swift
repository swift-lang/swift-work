import python;

string code1 =
----
from StringIO import StringIO
def get_string_io():
    return StringIO()
----;

string code2 =
----
sio = get_string_io()
----;

trace(python_persist(code1, "'ok1'")) =>
trace(python_persist(code2, "'ok2'"));
