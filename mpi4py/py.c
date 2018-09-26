
#include <Python.h>

#include <stdarg.h>
#include <stdio.h>
#include <stdbool.h>

static int verbosity = 0;

void
set_verbose(int level)
{
  verbosity = level;
}

void
verbose(char* fmt, ...)
{
  if (verbosity == 0) return;
  char b[1024];
  char* p = &b[0];
  p += sprintf(p, "py-eval: ");
  va_list ap;
  va_start(ap, fmt);
  p += vsprintf(p, fmt, ap);
  va_end(ap);
  puts(b);
  fflush(stdout);
}

void
crash(char* fmt, ...)
{
  printf("py-eval: abort: ");
  va_list ap;
  va_start(ap, fmt);
  vprintf(fmt, ap);
  va_end(ap);
  printf("\n");

  exit(EXIT_FAILURE);
}

static bool
handle_python_exception(void)
{
  printf("\n");
  printf("PYTHON EXCEPTION:\n");

  #if PYTHON_VERSION_MAJOR >= 3

  PyObject *exc,*val,*tb;
  PyErr_Fetch(&exc,&val,&tb);
  PyObject_Print(exc, stdout, Py_PRINT_RAW);
  printf("\n");
  PyObject_Print(val, stdout, Py_PRINT_RAW);
  printf("\n");

  #else // Python 2

  PyErr_Print();

  #endif

  return false;
}

static bool
handle_python_non_string(PyObject* o)
{
  printf("python: expression did not return a string!\n");
  fflush(stdout);
  printf("python: expression evaluated to: ");
  PyObject_Print(o, stdout, 0);
  printf("\n");
  return false;
}

static PyObject* main_module = NULL;
static PyObject* main_dict   = NULL;
static PyObject* local_dict  = NULL;

static bool initialized = false;

bool
python_init()
{
  if (initialized) return true;
  verbose("python: initializing...");
  Py_InitializeEx(1);
  main_module  = PyImport_AddModule("__main__");
  if (main_module == NULL) return handle_python_exception();
  main_dict = PyModule_GetDict(main_module);
  if (main_dict == NULL) return handle_python_exception();
  local_dict = PyDict_New();
  if (local_dict == NULL) return handle_python_exception();
  initialized = true;
  return true;
}

static char* python_result_default = "NOTHING";

/**
   @param persist: If true, retain the Python interpreter,
                   else finalize it
   @param code: The multiline string of Python code.

   @return true on success, false on error
 */
bool
python_code(const char* code)
{
  // Execute code:
  verbose("python: code: %s", code);
  PyRun_String(code, Py_file_input, main_dict, local_dict);
  if (PyErr_Occurred()) return handle_python_exception();
  return true;
}

/**
   The expr is evaluated to the returned result
   @param output: Store result pointer here
   @return true on success, false on exception
*/
bool python_eval(const char* expr, char** output)
{
  char* result = python_result_default;

  // Evaluate expression:
  verbose("python: expr: %s", expr);
  PyObject* o = PyRun_String(expr, Py_eval_input, main_dict, local_dict);
  if (PyErr_Occurred()) return handle_python_exception();
  // if (o == NULL) return handle_python_exception();

  // Convert Python result to C string
  int pc = PyArg_Parse(o, "s", &result);
  if (pc != 1) return handle_python_non_string(o);
  verbose("python: result: %s\n", result);
  *output = strdup(result);

  // Clean up and return:
  Py_DECREF(o);

  return true;
}

void python_finalize(void);

bool
python_reset()
{
  python_finalize();
  return python_init();
}

void
python_finalize()
{
  Py_Finalize();
  initialized = false;
}
