
def tf1(f_i, f_o):
    import shutil
    print(f"tf1: {f_i} -> {f_o}", flush=True)
    shutil.copyfile(f_i, f_o)
    return str(None)
