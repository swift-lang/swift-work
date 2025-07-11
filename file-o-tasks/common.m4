m4_divert(`-1')m4_changecom(`dnl')dnl
m4_define(`getenv', `m4_esyscmd(printf -- "$`$1'")')dnl
m4_divert
