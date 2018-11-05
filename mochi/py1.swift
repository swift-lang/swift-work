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

python_persist(code1, "'ok'");
python_persist(code2, "'ok'");
