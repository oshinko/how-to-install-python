import inspect
import sys
import traceback


def test_compression():
    import bz2  # noqa
    import gzip  # noqa
    import lzma  # noqa
    import zlib  # noqa


def test_ffi():
    import ctypes  # noqa


def test_gdbm():
    import dbm.gnu  # noqa


def test_openssl():
    import urllib.request

    def unknown_open(self, req):
        raise Exception(f'unknown url type: {req.type}')

    urllib.request.UnknownHandler.unknown_open = unknown_open

    try:
        urllib.request.urlopen('https://localhost/', timeout=0)
    except urllib.request.URLError:
        pass


def test_sqlite():
    import sqlite3  # noqa


def test_tk():
    import tkinter  #noqa


tests = [m for name, m in inspect.getmembers(sys.modules[__name__])
         if inspect.isfunction(m) and name.startswith('test_')]

error = False

for test in tests:
    try:
        test()
    except Exception:
        s = traceback.format_exc()
        print(s)
        error = True

print('NG' if error else 'OK')

exit(1 if error else 0)
