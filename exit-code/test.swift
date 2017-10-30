
import io;

(int exit_code) shell(string args[])
"turbine" "1.0"
[
"""
source exit-code.tcl
set D <<args>>
set <<exit_code>> [ system [ dict values <<args>> ] ]
"""
 ];  

cmds = [ "true", "false" ];
foreach cmd in cmds
{
  ec = shell([cmd]);
  printf("%s -> %i", cmd, ec);
}
