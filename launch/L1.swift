
import launch;
import unix;

v = mkdir("subdir");

string args[] = [];
string envs[] = [ "X=3", "swift_chdir=subdir"
                       // , "swift_launcher=ZZZ" // this will cause an error
                        ];
v => @par=2 launch_envs("../command.sh", args, envs);
