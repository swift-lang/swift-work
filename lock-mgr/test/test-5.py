
# TEST 5
# Try with SQL

import random
import time
import sqlite3
import _wlmpy

sql_create = """
create table records(
rowid integer primary key,
time timestamp,
rank integer);
"""

conn   = None
cursor = None

def connect():
    global conn, cursor
    print("connect: rank=%i" % rank)
    conn = sqlite3.connect("test.db")
    cursor = conn.cursor()

def insert():
    global conn, rank
    print("insert: rank=%i" % rank)
    cmd = "insert into records (time, rank) values (%i,%i);" % \
        (time.time(), rank)
    conn.execute(cmd)
    conn.commit()

rank = _wlmpy.wlm_mpi_init()

if rank == 0:
    connect()
    conn.execute(sql_create)
    conn.commit()
    _wlmpy.wlm_init(True, 0)
else:
    _wlmpy.wlm_init(False, 0)

    # Test that the manager is ready before connecting
    _wlmpy.wlm_acquire(0)
    _wlmpy.wlm_release(0)

    connect()

    for i in range(0,5):
        # _wlmpy.wlm_acquire(0)
        # time.sleep(random.randint(0,100)/1000.0)
        insert()
        # _wlmpy.wlm_release(0)

    _wlmpy.wlm_shutdown(0)

_wlmpy.wlm_mpi_finalize()
conn.close()
