foreach v, i in infiles {
  file out <sprintf(“/mnt/bb/ketan2/output-data/%s”,basename(v))> = subuid(sedscript, v);
 }
