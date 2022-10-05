
import io;
import launch;

@par=3 launch_envs("app.x", [],
                   [ "swift_launcher=srun",
                     "swift_launcher_options=--nodes=1"] );

printf("HELLO");
